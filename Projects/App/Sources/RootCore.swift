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
import Models
import Services

@Reducer
public struct RootCore {
  @ObservableState
  public struct State: Equatable {
    public var isLogin: Bool = false
    public var login: LoginCore.State = LoginCore.State()
  }
  
  public enum Action {
    case onAppear
    case readAccessToken(Result<String, Error>)
    case readRefreshToken(Result<String, Error>)
    case checkAccessToken(Result<TestInformation?, Error>)
    case refreshToken(Result<TokenInformation?, Error>)
    case setLoginStatus(Bool)
    case login(LoginCore.Action)
    case onOpenURL(URL)
    case logError(RootCoreError)
  }
  
  @Dependency(\.kakaoAPIClient) var kakaoAPIClient
  @Dependency(\.kakaoLoginClient) var kakaoLoginClient
  @Dependency(\.keyChainClient) var keyChainClient
  
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
        
      case let .checkAccessToken(.success(testInformation)):
        return .run { send in
          await send(.setLoginStatus(true))
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
        return .run(
          operation: { send in
            try await self.keyChainClient.update(.accessToken, tokenInformation.accessToken)
            try await self.keyChainClient.update(.refreshToken, tokenInformation.refreshToken)
            await send(.setLoginStatus(true))
          },
          catch: {
            await send(.logError(RootCoreError(code: .failToSaveToken)))
          }
        )
        
      case .refreshToken(.failure):
        return .run { send in
          await send(.setLoginStatus(false))
        }
        
      case let .setLoginStatus(isLogin):
        state.isLogin = isLogin
        return .none
        
      case .login(.delegate(.checkLogin(let isLogin))):
        state.isLogin = isLogin
        return .none
        
      case .login:
        return .none
        
      case let .onOpenURL(url):
        return .run { send in
          kakaoLoginClient.openURL(url)
        }
        
      case let .logError(error):
        logger.error("RootCore Error: \(String(describing: error))")
        return .none
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
    case failToGetToken
    case failToSaveToken
  }
}

