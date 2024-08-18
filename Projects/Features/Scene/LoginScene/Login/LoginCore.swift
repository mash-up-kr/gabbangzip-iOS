//
//  LoginCore.swift
//  Login
//
//  Created by Hyun A Song on 6/24/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

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
    case loginButtonTapped
    
    // Internal Action
    case loginWithKakaoTalkResponse(Result<String?, Error>)
    case loginWithKakaoAccountResponse(Result<String?, Error>)
    case checkUserInformationResponse(Result<User, Error>)
    case loginResponse(Result<PICUserInfo, Error>)
    case getFCMToken(String)
    case postFCMToken
    case responseFCMToken(Result<RegisteredFCMToken, Error>)
    case saveUserInfoToKeychain(Result<Void, Error>)
    case showError(Bool)
    case logError(LoginCoreError)
    
    // Route Action
    case moveToHome
  }
  
  @Dependency(\.authAPIClient) private var authAPIClient
  @Dependency(\.firebaseClient) private var firebaseClient
  @Dependency(\.kakaoLoginClient) private var kakaoLoginClient
  @Dependency(\.keyChainClient) private var keyChainClient
  @Dependency(\.userDefaultsClient) private var userDefaultsClient
  @Dependency(\.pushNotificationAPIClient) private var pushNotificationAPIClient
  
  public var body: some Reducer<State, Action> {
    BindingReducer()
    
    Reduce { state, action in
      switch action {
      case .binding:
        return .none
        
      case .loginButtonTapped:
        return .run { send in
          if kakaoLoginClient.isKakaoTalkLoginAvailable() {
            await send(.loginWithKakaoTalkResponse(Result { try await self.kakaoLoginClient.loginWithKakaoTalk() }))
          } else {
            await send(.loginWithKakaoAccountResponse(Result { try await self.kakaoLoginClient.loginWithKakaoAccount() }))
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
            await send(.loginResponse(Result { try await authAPIClient.login(idToken, nickname, profileImageUrl) }))
          } else {
            await send(.loginResponse(.failure(LoginCoreError(code: .failToCheckUserInformation))))
          }
        } catch: { error,send in
          await send(.loginResponse(.failure(LoginCoreError(code: .failToRegistrationToken, underlying: error))))
        }
        
      case .checkUserInformationResponse(.failure):
        return .run { send in
          await send(.showError(true))
        }
        
      case let .loginResponse(.success(user)):
        let userInfo = UserInfo(
          userID: user.userID,
          nickname: user.nickname,
          accessToken: user.accessToken,
          refreshToken: user.refreshToken
        )
        state.userInfo = userInfo
        return .run { send in
          await send(.saveUserInfoToKeychain(Result { try await self.keyChainClient.createUserInfo(userInfo) }))
          await send(.moveToHome)
        }
        
      case .loginResponse(.failure):
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
        
      case let .showError(isPresented):
        state.isPresented = isPresented
        return .none
        
      case let .logError(error):
        return .run { send in
          logger.error("MyPage Error: \(error)")
        }
        
      case .moveToHome:
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
