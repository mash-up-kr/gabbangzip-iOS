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
    case setLoginStatus(Bool)
    case login(LoginCore.Action)
    case onOpenURL(URL)
    case showError(RootCoreError)
  }
  
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
        return .run (
          operation: { send in
            let tokenData = try await keyChainClient.read(.accessToken)
            let tokenExists = !tokenData.isEmpty
            await send(.setLoginStatus(tokenExists))
          },
          catch: { error, send in
            await send(.setLoginStatus(false))
            await send(.showError(RootCoreError(code: .failToGetToken)))
          }
        )
        
      case let .setLoginStatus(isLogin):
        state.isLogin = isLogin
        return .none
        
      case .login:
        return .none
        
      case let .onOpenURL(url):
        return .run { send in
          kakaoLoginClient.openURL(url)
        }
        
      case let .showError(error):
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
  }
}

