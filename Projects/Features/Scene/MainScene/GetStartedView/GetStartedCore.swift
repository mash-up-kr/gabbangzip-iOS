//
//  GetStartedCore.swift
//  Main
//
//  Created by YangJoonHyeok on 7/9/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import ComposableArchitecture

@Reducer
public struct GetStartedCore {
  public init() {}
  
  public struct State: Equatable {
    public init() {}
  }

  public enum Action {
    // View Action
    case createGroupButtonTapped
    case inviteCodeButtonTapped
    
    // Route Action
    case moveToSetGroupName
    case moveToJoinGroup
  }

  public var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .createGroupButtonTapped:
        return .send(.moveToSetGroupName)
        
      case .inviteCodeButtonTapped:
        return .none
        
      case .moveToSetGroupName:
        return .none
        
      case .moveToJoinGroup:
        return .none
      }
    }
  }
}
