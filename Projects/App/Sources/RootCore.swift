//
//  RootCore.swift
//  App
//
//  Created by Hyun A Song on 6/19/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import Common
import ComposableArchitecture
import Foundation
import KakaoLogin
import KakaoSDKUser
import Models
import Services

@Reducer
public struct RootCore {
  @ObservableState
  public struct State: Equatable {
    public var isLogin: Bool = true
    public var login: LoginCore.State = LoginCore.State()
    public var nickname: String = ""
  }
  
  public enum Action {
    case onAppear
    case readAccessToken(Result<String, Error>)
    case readRefreshToken(Result<String, Error>)
    case checkAccessToken(Result<TestInfo?, Error>)
    case refreshToken(Result<TokenInfo?, Error>)
    case updateToken(Result<(KeyChainClient.Key, String), RootCoreError>)
    case getUser(Result<User, Error>)
    case updateUser(UserDefaultsClient.Key, String)
    case setLoginStatus(Bool)
    case getNickname
    case setNickname(Result<String, Error>)
    case login(LoginCore.Action)
    case onOpenURL(URL)
    case logError(RootCoreError)
  }
  
  @Dependency(\.kakaoAPIClient) private var kakaoAPIClient
  @Dependency(\.kakaoLoginClient) private var kakaoLoginClient
  @Dependency(\.keyChainClient) private var keyChainClient
  @Dependency(\.userDefaultsClient) private var userDefaultsClient
  
  public var body: some Reducer<State, Action> {
    Scope(
      state: \.login,
      action: \.login,
      child: LoginCore.init
    )
    
    Reduce { state, action in
      switch action {
      case .onAppear:
        return .run { send in
          await send(
            .readAccessToken(
              Result {
                try await self.keyChainClient.read(.accessToken)
              }
            )
          )
          await send(.getNickname)
        }
        
      case let .readAccessToken(.success(accessToken)):
        return .run { send in
          await send(
            .checkAccessToken(
              Result {
                try await self.kakaoAPIClient.testToken(accessToken)
              }
            )
          )
        }
        
      case .readAccessToken(.failure):
        return .run { send in
          await send(.setLoginStatus(false))
        }
        
      case let .readRefreshToken(.success(refreshToken)):
        return .run { send in
          await send(
            .refreshToken(
              Result {
                try await self.kakaoAPIClient.refreshToken(refreshToken)
              }
            )
          )
        }
        
      case .readRefreshToken(.failure):
        return .run { send in
          await send(.setLoginStatus(false))
        }
        
      case let .checkAccessToken(.success(testInfo)):
        return .run { send in
          if testInfo != nil {
            await send(.setLoginStatus(true))
          } else {
            await send(.setLoginStatus(false))
          }
        }
        
      case .checkAccessToken(.failure):
        return .run { send in
          await send(
            .readRefreshToken(
              Result {
                try await self.keyChainClient.read(.refreshToken)
              }
            )
          )
        }
        
      case let .refreshToken(.success(tokenInformation)):
        return .run { send in
          if let accessToken = tokenInformation?.accessToken {
            await send(.updateToken(.success((.accessToken, accessToken))))
          } else {
            await send(.updateToken(.failure(RootCoreError(code: .failToSaveToken))))
          }
          if let refreshToken = tokenInformation?.refreshToken {
            await send(.updateToken(.success((.refreshToken, refreshToken))))
          } else {
            await send(.updateToken(.failure(RootCoreError(code: .failToSaveToken))))
          }
          await send(
            .getUser(
              Result {
                try await kakaoLoginClient.checkUserInformation()
              }
            )
          )
          await send(.setLoginStatus(true))
        }
        
      case .refreshToken(.failure):
        return .run { send in
          await send(.setLoginStatus(false))
        }
        
      case let .updateToken(.success((tokenKey, token))):
        return .run { send in
          try await keyChainClient.update(tokenKey, token)
        }
        
      case let .updateToken(.failure(error)):
        return .run { send in
          await send(.logError(error))
        }
        
      case let .getUser(.success(user)):
        return .run { send in
          if let nickname = user.kakaoAccount?.profile?.nickname {
            await send(.updateUser(.nickname, nickname))
          } else {
            await send(.logError(RootCoreError(code: .failToGetNickname)))
          }
        }
        
      case .getUser(.failure):
        return .run { send in
          await send(.logError(RootCoreError(code: .failToGetNickname)))
        }
        
      case let .updateUser(key, value):
        return .run { send in
          userDefaultsClient.set(value, key)
        }
        
      case let .setLoginStatus(isLogin):
        state.isLogin = isLogin
        return .none
        
      case .getNickname:
        return .run { send in
          await send(
            .setNickname(
              Result {
                try userDefaultsClient.string(.nickname)
              }
            )
          )
        }
        
      case let .setNickname(.success(nickname)):
        state.nickname = nickname
        return .none
        
      case .setNickname(.failure):
        return .run { send in
          await send(.logError(RootCoreError(code: .failToSetNickName)))
        }
        
      case let .login(.delegate(.checkLogin(isLogin))):
        state.isLogin = isLogin
        return .none
        
      case .login:
        return .none
        
      case let .onOpenURL(url):
        return .run { send in
          let isKakaoOpened = kakaoLoginClient.openURL(url)
          
          if !isKakaoOpened {
            await send(.logError(RootCoreError(code: .failToOpenKakao)))
          }
        }
        
      case let .logError(error):
        return .run { send in
          logger.error("RootCore Error: \(error)")
        }
      }
    }
  }
}

// MARK: - RootCoreError
public struct RootCoreError: GabbangzipError {
  public var userInfo: [String: Any] = [:]
  public var code: Code
  public var underlying: Error?
  
  public enum Code: Int {
    case failToGetNickname
    case failToGetToken
    case failToSaveToken
  }
}

