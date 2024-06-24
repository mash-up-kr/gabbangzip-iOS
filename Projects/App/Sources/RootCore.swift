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
    public var login: LoginCore.State = LoginCore.State()
  }
  
  public enum Action {
    case login(LoginCore.Action)
    case onOpenURL(URL)
  }
  
  @Dependency(\.kakaoLoginClient) var kakaoLoginClient
  
  public var body: some Reducer<State, Action> {
    Scope(state: \.login,
          action: \.login) {
      LoginCore()
    }
    
    Reduce { state, action in
      switch action {
      case .login(_):
        return .none
        
      case let .onOpenURL(url):
        return .run { send in
          kakaoLoginClient.openURL(url)
        }
      }
    }
  }
}
