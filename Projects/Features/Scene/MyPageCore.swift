//
//  MyPageCore.swift
//  MyPage
//
//  Created by Hyun A Song on 7/5/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import ComposableArchitecture
import Services

@Reducer
public struct MyPageCore {
  public init() {}

  @ObservableState
  public struct State: Equatable {
    public let myPageTitle = "마이페이지"
    public var nickname: String
    
    public init(nickname: String) {
      self.nickname = nickname
    }
  }

  public enum Action {
    case first
  }
  
  @Dependency(\.userDefaultsClient) private var userDefaultsClient

  public var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .first:
        return .none
      }
    }
  }
}
