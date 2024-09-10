//
//  LoginCore.swift
//  Login
//
//  Created by Hyun A Song on 6/24/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import AuthenticationServices
import Common
import ComposableArchitecture
import Foundation
import KakaoSDKUser
import Models
import Services

@Reducer
public struct LoginCore {
  public init() {}
  
  @ObservableState
  public struct State: Equatable {
    @Shared var userInfo: UserInfo
    public var isPresented: Bool
    public var kakaoUser: KaKaoUserInfo
    public var kakaoIdToken: KakaoToken
    public var fcmToken: String
    
    public init(
      userInfo: @autoclosure () -> UserInfo = .defaultValue,
      isPresented: Bool = false,
      kakaoUser: KaKaoUserInfo = KaKaoUserInfo(),
      kakaoIdToken: KakaoToken = KakaoToken(),
      fcmToken: String = ""
    ) {
      self._userInfo = Shared(wrappedValue: userInfo(), .inMemory("userInfo"))
      self.isPresented = isPresented
      self.kakaoUser = kakaoUser
      self.kakaoIdToken = kakaoIdToken
      self.fcmToken = fcmToken
    }
  }
  
  public enum Action: BindableAction {
    case binding(BindingAction<State>)
    
    // View Action
    case kakaoLoginButtonTapped
    case appleSignInCompleted(Result<ASAuthorization, any Error>)
    
    // Internal Action
    case loginWithKakaoTalkResponse(Result<String?, Error>)
    case loginWithKakaoAccountResponse(Result<String?, Error>)
    case checkUserInformationResponse(Result<User, Error>)
    case kakaoLoginResponse(Result<PICUserInfo, Error>)
    case appleLoginResponse(Result<PICUserInfo, Error>)
    case getFCMToken(String)
    case postFCMToken
    case responseFCMToken(Result<RegisteredFCMToken, Error>)
    case saveUserInfoToKeychain(Result<Void, Error>)
    case getGroupsResponse(Result<GroupsData, Error>)
    case showError(Bool)
    case logError(LoginCoreError)
    
    // Route Action
    case moveToHome
    case moveToGetStarted
  }
  
  @Dependency(\.authAPIClient) private var authAPIClient
  @Dependency(\.firebaseClient) private var firebaseClient
  @Dependency(\.kakaoLoginClient) private var kakaoLoginClient
  @Dependency(\.keyChainClient) private var keyChainClient
  @Dependency(\.userDefaultsClient) private var userDefaultsClient
  @Dependency(\.pushNotificationAPIClient) private var pushNotificationAPIClient
  @Dependency(\.groupAPIClient) private var groupAPIClient
  
  public var body: some Reducer<State, Action> {
    BindingReducer()
    
    Reduce { state, action in
      switch action {
      case .binding:
        return .none
        
      case .kakaoLoginButtonTapped:
        return .run { send in
          if kakaoLoginClient.isKakaoTalkLoginAvailable() {
            await send(.loginWithKakaoTalkResponse(Result { try await self.kakaoLoginClient.loginWithKakaoTalk() }))
          } else {
            await send(.loginWithKakaoAccountResponse(Result { try await self.kakaoLoginClient.loginWithKakaoAccount() }))
          }
        }
        
      case let .appleSignInCompleted(result):
        return .run { send in
          switch result {
          case let .success(authorization):
            if let userCredential = authorization.credential as? ASAuthorizationAppleIDCredential,
               let idToken = userCredential.identityToken,
               let encodedIdToken = String(data: idToken, encoding: .utf8) {
              
              let fullNameString: String? = {
                if let fullName = userCredential.fullName {
                  let formatter = PersonNameComponentsFormatter()
                  return formatter.string(from: fullName)
                } else {
                  return nil
                }
              }()
              
              await send(.appleLoginResponse(Result {
                try await authAPIClient.appleLogin(
                  idToken: encodedIdToken,
                  fullName: fullNameString,
                  user: userCredential.user
                )
              }))
            }
          case let .failure(error):
            await send(.showError(true))
          }
        }
        
      case let .loginWithKakaoTalkResponse(.success(idToken)):
        state.kakaoIdToken.idToken = idToken
        return .run { send in
          await send(.checkUserInformationResponse(Result { try await kakaoLoginClient.checkUserInformation() }))
        }
        
      case .loginWithKakaoTalkResponse(.failure):
        return .run { send in
          await send(.showError(true))
        }
        
      case let .loginWithKakaoAccountResponse(.success(idToken)):
        state.kakaoIdToken.idToken = idToken
        return .run { send in
          await send(.checkUserInformationResponse(Result { try await kakaoLoginClient.checkUserInformation() }))
        }
        
      case .loginWithKakaoAccountResponse(.failure):
        return .run { send in
          await send(.showError(true))
        }
        
      case let .checkUserInformationResponse(.success(user)):
        state.kakaoUser.nickname = user.kakaoAccount?.profile?.nickname
        state.kakaoUser.profileImageUrl = user.kakaoAccount?.profile?.profileImageUrl
        return .run { [state] send in
          if let idToken = state.kakaoIdToken.idToken,
             let nickname = state.kakaoUser.nickname,
             let profileImageUrl = state.kakaoUser.profileImageUrl?.absoluteString {
            let token = try await firebaseClient.checkRegistrationToken()
            await send(.getFCMToken(token))
            await send(.kakaoLoginResponse(Result { try await authAPIClient.kakaoLogin(idToken, nickname, profileImageUrl) }))
          } else {
            await send(.kakaoLoginResponse(.failure(LoginCoreError(code: .failToCheckUserInformation))))
          }
        } catch: { error,send in
          await send(.kakaoLoginResponse(.failure(LoginCoreError(code: .failToRegistrationToken, underlying: error))))
        }
        
      case .checkUserInformationResponse(.failure):
        return .run { send in
          await send(.showError(true))
        }
        
      case let .kakaoLoginResponse(.success(user)):
        let userInfo = UserInfo(
          userID: user.userID,
          nickname: user.nickname,
          accessToken: user.accessToken,
          refreshToken: user.refreshToken,
          loginType: .kakao
        )
        state.userInfo = userInfo
        return .run { send in
          await send(.saveUserInfoToKeychain(Result { try await self.keyChainClient.createUserInfo(userInfo) }))
          await send(.getGroupsResponse(Result {
            try await self.groupAPIClient.getGroups(userInfo.accessToken)
          }))
        }
        
      case .kakaoLoginResponse(.failure):
        return .run { send in
          await send(.logError(LoginCoreError(code: .failToLogin)))
          await send(.showError(true))
        }
        
      case let .appleLoginResponse(.success(user)):
        let userInfo = UserInfo(
          userID: user.userID,
          nickname: user.nickname,
          accessToken: user.accessToken,
          refreshToken: user.refreshToken,
          loginType: .apple
        )
        state.userInfo = userInfo
        return .run { send in
          await send(.saveUserInfoToKeychain(Result { try await self.keyChainClient.createUserInfo(userInfo) }))
          await send(.getGroupsResponse(Result {
            try await self.groupAPIClient.getGroups(userInfo.accessToken)
          }))
        }
        
      case .appleLoginResponse(.failure):
        return .run { send in
          await send(.logError(LoginCoreError(code: .failToLogin)))
          await send(.showError(true))
        }
        
      case let .getFCMToken(token):
        state.fcmToken = token
        return .run { send in
          await send(.postFCMToken)
        }
        
      case .postFCMToken:
        return .run { [state] send in
          await send(.responseFCMToken(Result {
            try await self.pushNotificationAPIClient.registerFCMToken(
              state.userInfo.accessToken,
              state.fcmToken
            )
          }))
        }
        
      case .responseFCMToken(.success):
        return .none
        
      case .responseFCMToken(.failure):
        return .run { send in
          await send(.logError(LoginCoreError(code: .failToPostFCMToken)))
        }
        
      case .saveUserInfoToKeychain(.success):
        return .none
        
      case .saveUserInfoToKeychain(.failure):
        return .run { send in
          await send(.logError(LoginCoreError(code: .failToSaveUserInfoToKeychain)))
        }
        
      case let .getGroupsResponse(.success(groupsData)):
        let isMemberOfAnyGroup = !groupsData.groups.isEmpty
        return .send(isMemberOfAnyGroup ? .moveToHome : .moveToGetStarted)
        
      case .getGroupsResponse(.failure):
        return .send(.moveToHome)
        
      case let .showError(isPresented):
        state.isPresented = isPresented
        return .none
        
      case let .logError(error):
        return .run { send in
          logger.error("MyPage Error: \(error)")
        }
        
      case .moveToHome:
        return .none
        
      case .moveToGetStarted:
        return .none
      }
    }
  }
}

// MARK: - LoginCoreError
public struct LoginCoreError: GabbangzipError {
  public var userInfo: [String: Any] = [:]
  public var code: Code
  public var underlying: Error?
  
  public enum Code: Int {
    case failToRegistrationToken
    case failToCheckUserInformation
    case failToLogin
    case failToPostFCMToken
    case failToSaveUserInfoToKeychain
  }
}
