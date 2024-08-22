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
    case testLoginButtonTapped
    
    // Internal Action
    case loginWithKakaoTalkResponse(Result<String?, Error>)
    case loginWithKakaoAccountResponse(Result<String?, Error>)
    case checkUserInformationResponse(Result<User, Error>)
    case loginResponse(Result<PICUserInfo, Error>)
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
        
      case .loginButtonTapped:
        return .run { send in
          if kakaoLoginClient.isKakaoTalkLoginAvailable() {
            await send(.loginWithKakaoTalkResponse(Result { try await self.kakaoLoginClient.loginWithKakaoTalk() }))
          } else {
            await send(.loginWithKakaoAccountResponse(Result { try await self.kakaoLoginClient.loginWithKakaoAccount() }))
          }
        }
        
      // TEST: - 앱 심사용 테스트 코드
      // swiftlint:disable line_length
      case .testLoginButtonTapped:
        state.kakaoUser.nickname = "테스트계정"
        state.kakaoUser.profileImageUrl = URL(string: "https://img1.kakaocdn.net/thumb/R640x640.q70/?fname=https://t1.kakaocdn.net/account_images/default_profile.jpeg")
        state.kakaoIdToken.idToken = "eyJraWQiOiI5ZjI1MmRhZGQ1ZjIzM2Y5M2QyZmE1MjhkMTJmZWEiLCJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiI3ODBkODIwZDA3NDZhZmZlZWIyNTFhZGYwYWRlNjA3NSIsInN1YiI6IjM2NjM1MTc1MjgiLCJhdXRoX3RpbWUiOjE3MjQyODUyMTksImlzcyI6Imh0dHBzOi8va2F1dGgua2FrYW8uY29tIiwibmlja25hbWUiOiLthYzsiqTtirjqs4TsoJUiLCJleHAiOjE3MjQzMjg0MTksImlhdCI6MTcyNDI4NTIxOSwicGljdHVyZSI6Imh0dHBzOi8vaW1nMS5rYWthb2Nkbi5uZXQvdGh1bWIvUjExMHgxMTAucTcwLz9mbmFtZT1odHRwczovL3QxLmtha2FvY2RuLm5ldC9hY2NvdW50X2ltYWdlcy9kZWZhdWx0X3Byb2ZpbGUuanBlZyJ9.AE-s4nm9hBu_RSUw-j6_yNU8Sx_cRfEqNdxJwPuXa2LOEYNItrshyADjBfhfZhfk0o6jvL-tDzAPxN9yDiHBW0MFKjzxJDYihDHZ1vh-bVLP2FQDgaA-txgWr9OG5oQZ180L3THeDvRpUTNcGvh85SYqEAk7IuFTSqmC1J2HZv_yL2vjF2khFkCeMAXe5N9Y8ga6jhdIQ3jH86YjD-mlqiq6kDNzuNbzy5odotj4Lcbgc7Q5occbRgzShC4FX_q676DG0MEJaGvhQqIeSoxn9iXUmJKlN_anNA_MTqfcfdM3zRn8MqkHDA0m4Hfogv3ss_oyOfKlsLzo_YuGt9iodg"
        return .run { [state] send in
          if let idToken = state.kakaoIdToken.idToken,
             let nickname = state.kakaoUser.nickname,
             let profileImageUrl = state.kakaoUser.profileImageUrl?.absoluteString {
            let token = try await firebaseClient.checkRegistrationToken()
            await send(.getFCMToken(token))
            await send(.loginResponse(Result { try await
              authAPIClient.login(idToken, nickname, profileImageUrl) }))
          } else {
            await send(.loginResponse(.failure(LoginCoreError(code: .failToCheckUserInformation))))
          }
        } catch: { error,send in
          await send(.loginResponse(.failure(LoginCoreError(code: .failToRegistrationToken, underlying: error))))
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
          await send(.getGroupsResponse(Result {
            try await self.groupAPIClient.getGroups(userInfo.accessToken)
          }))
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
