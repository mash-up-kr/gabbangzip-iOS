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
    
    public init(
      isPresented: Bool = false,
      kakaoUser: KaKaoUserInfo = KaKaoUserInfo(),
      kakaoIdToken: KakaoToken = KakaoToken()
    ) {
      self.isPresented = isPresented
      self.kakaoUser = kakaoUser
      self.kakaoIdToken = kakaoIdToken
    }
  }
  
  public enum Action: BindableAction {
    case loginButtonTapped
    case loginWithKakaoTalkResponse(Result<String?, Error>)
    case loginWithKakaoAccountResponse(Result<String?, Error>)
    case checkUserInformationResponse(Result<User, Error>)
    case loginResponse(Result<PICUserInfo?, Error>)
    case saveTokenInKeyChain(Result<(KeyChainClient.Key, String), LoginCoreError>)
    case saveUserInUserDefaults(Result<(UserDefaultsClient.Key, String), LoginCoreError>)
    case showError(Bool)
    case binding(BindingAction<State>)
    case delegate(Delegate)
    case logError(LoginCoreError)
    
    public enum Delegate {
      case checkLogin(Bool)
    }
  }
  
  @Dependency(\.kakaoLoginClient) private var kakaoLoginClient
  @Dependency(\.kakaoAPIClient) private var kakaoAPIClient
  @Dependency(\.keyChainClient) private var keyChainClient
  @Dependency(\.userDefaultsClient) private var userDefaultsClient
  
  public var body: some Reducer<State, Action> {
    BindingReducer()
    
    Reduce { state, action in
      switch action {
      case .loginButtonTapped:
        return .run { send in
          if kakaoLoginClient.isKakaoTalkLoginAvailable() {
            await send(
              .loginWithKakaoTalkResponse(
                Result {
                  try await self.kakaoLoginClient.loginWithKakaoTalk()
                }
              )
            )
          } else {
            await send(
              .loginWithKakaoAccountResponse(
                Result {
                  try await self.kakaoLoginClient.loginWithKakaoAccount()
                }
              )
            )
          }
        }
        
      case let .loginWithKakaoTalkResponse(.success(idToken)):
        state.kakaoIdToken.idToken = idToken
        return .run { send in
          await send(
            .checkUserInformationResponse(
              Result {
                try await kakaoLoginClient.checkUserInformation()
              }
            )
          )
        }
        
      case .loginWithKakaoTalkResponse(.failure):
        return .run { send in
          await send(.showError(true))
        }
        
      case let .loginWithKakaoAccountResponse(.success(idToken)):
        state.kakaoIdToken.idToken = idToken
        return .run { send in
          await send(
            .checkUserInformationResponse(
              Result {
                try await kakaoLoginClient.checkUserInformation()
              }
            )
          )
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
            await send(
              .loginResponse(
                Result {
                  try await kakaoAPIClient.login(
                    idToken,
                    nickname,
                    profileImageUrl
                  )
                }
              )
            )
          } else {
            await send(.loginResponse(.failure(LoginCoreError(code: .failToCheckUserInformation))))
          }
        }
        
      case .checkUserInformationResponse(.failure):
        return .run { send in
          await send(.showError(true))
        }
        
      case let .loginResponse(.success(user)):
        return .run { send in
          if let accessToken = user?.accessToken {
            await send(.saveTokenInKeyChain(.success((.accessToken, accessToken))))
          } else {
            await send(.saveTokenInKeyChain(.failure(LoginCoreError(code: .failToGetAccessToken))))
          }
          if let refreshToken = user?.refreshToken {
            await send(.saveTokenInKeyChain(.success((.refreshToken, refreshToken))))
          } else {
            await send(.saveTokenInKeyChain(.failure(LoginCoreError(code: .failToGetRefreshToken))))
          }
          if let nickname = user?.nickname {
            await send(.saveUserInUserDefaults(.success((.nickname, nickname))))
          } else {
            await send(.logError(LoginCoreError(code: .failToGetNickname)))
          }
        }
        
      case let .loginResponse(.failure(error)):
        return .run { send in
          await send(.logError(LoginCoreError(code: .failToLogin)))
          await send(.showError(true))
        }
        
      case let .saveTokenInKeyChain(.success((tokenKey, token))):
        return .run { send in
          try await keyChainClient.create(tokenKey, token)
          await send(.delegate(.checkLogin(true)))
        }
        
      case let .saveTokenInKeyChain(.failure(error)):
        return .run { send in
          await send(.logError(LoginCoreError(code: .failToSaveTokenInKeyChain)))
        }
        
      case let .saveUserInUserDefaults(.success((key, value))):
        return .run { send in
          userDefaultsClient.set(value, key)
        }
        
      case let .showError(isPresented):
        state.isPresented = isPresented
        return .none
        
      case .binding:
        return .none
        
      case .delegate:
        return .none
        
      case let .logError(error):
        return .run { send in
          logger.error("MyPage Error: \(error)")
        }
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
    case failToGetAccessToken
    case failToGetRefreshToken
    case failToGetUser
    case failToGetNickname
    case failToLogin
    case failToSaveTokenInKeyChain
  }
}
