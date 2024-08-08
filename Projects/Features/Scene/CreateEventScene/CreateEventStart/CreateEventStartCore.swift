//
//  CreateEventStartCore.swift
//  CreateEvent
//
//  Created by Hyun A Song on 8/8/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import ComposableArchitecture

@Reducer
public struct CreateEventStartCore {
  public init() {}
  
  @ObservableState
  public struct State: Equatable {
    public var groupName: String
    
    public init(
      groupName: String
    ) {
      self.groupName = groupName
    }
  }

  public enum Action {
    // View Action
    case onAppear
    case createEventButtonTapped
    
    // Route Action
    case moveToGroupDetail
    case moveToGroupMemberList
    case moveToCreateEventProcess
  }

  public var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .onAppear:
        return .none
        
      case .createEventButtonTapped:
        return .send(.moveToCreateEventProcess)
        
      case .moveToGroupDetail:
        return .none
        
      case .moveToGroupMemberList:
        return .none
        
      case .moveToCreateEventProcess:
        return .none
      }
    }
  }
}
