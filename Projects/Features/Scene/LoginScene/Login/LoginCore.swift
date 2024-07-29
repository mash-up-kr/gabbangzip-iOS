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
    public var isPresented: Bool
    public var kakaoUser: KaKaoUserInfo
    public var kakaoIdToken: KakaoToken
    @Shared var userInfo: UserInfo
    
    public init(
      isPresented: Bool = false,
      kakaoUser: KaKaoUserInfo = KaKaoUserInfo(),
      kakaoIdToken: KakaoToken = KakaoToken(),
      userInfo: @autoclosure () -> UserInfo = .defaultValue
    ) {
      self.isPresented = isPresented
      self.kakaoUser = kakaoUser
      self.kakaoIdToken = kakaoIdToken
      self._userInfo = Shared(wrappedValue: userInfo(), .inMemory("userInfo"))
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
    case saveUserInfoToKeychain(Result<Void, Error>)
    case showError(Bool)
    case logError(LoginCoreError)
    
    // Route Action
    case moveToHome
  }
  
  @Dependency(\.kakaoLoginClient) private var kakaoLoginClient
  @Dependency(\.authAPIClient) private var authAPIClient
  @Dependency(\.keyChainClient) private var keyChainClient
  @Dependency(\.userDefaultsClient) private var userDefaultsClient
  
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
            await send(.loginResponse(Result { try await authAPIClient.login(idToken, nickname, profileImageUrl) }))
          } else {
            await send(.loginResponse(.failure(LoginCoreError(code: .failToCheckUserInformation))))
          }
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
    case failToCheckUserInformation
    case failToLogin
    case failToSaveUserInfoToKeychain
  }
}
