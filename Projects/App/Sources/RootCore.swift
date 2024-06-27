//
//  RootCore.swift
//  App
//
//  Created by Hyun A Song on 6/19/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import ComposableArchitecture
import Foundation
import KakaoLogin

@Reducer
public struct RootCore {
  @ObservableState
  public struct State: Equatable {
    public var isLogin: Bool = false
    public var login: LoginCore.State = LoginCore.State()
  }
  
  public enum Action {
    case checkAccessToken
    case setLoginStatus(Bool)
    case login(LoginCore.Action)
    case onOpenURL(URL)
  }
  
  @Dependency(\.kakaoLoginClient) var kakaoLoginClient
  @Dependency(\.keyChainClient) var keyChainClient
  
  public var body: some Reducer<State, Action> {
    Scope(
      state: \.login,
      action: \.login
    ) {
      LoginCore()
    }
    
    Reduce { state, action in
      switch action {
      case .checkAccessToken:
        return .run { send in
          var tokenExists = false
          do {
            let data = try await keyChainClient.read(.accessToken)
            tokenExists = data != nil
          } catch {
            tokenExists = false
          }
          await send(.setLoginStatus(tokenExists))
        }
        
      case let .setLoginStatus(isLogin):
        state.isLogin = isLogin
        return .none
        
      case .login:
        return .none
        
      case let .onOpenURL(url):
        return .run { send in
          kakaoLoginClient.openURL(url)
        }
      }
    }
  }
}
