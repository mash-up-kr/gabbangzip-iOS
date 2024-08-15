//
//  CreateGroupCoordinatorCore.swift
//  CreateGroupCoordinator
//
//  Created by YangJoonHyeok on 7/21/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import ComposableArchitecture
import TCACoordinators

@Reducer
public struct CreateGroupCoordinatorCore {
  public init() {}
  
  @ObservableState
  public struct State: Equatable {
    var routes: [Route<CreateGroupScreen.State>]
    
    public init(routes: [Route<CreateGroupScreen.State>]) {
      self.routes = routes
    }
  }
  
  public enum Action {
    case router(IndexedRouterActionOf<CreateGroupScreen>)
  }
  
  public var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case let .router(.routeAction(id: _, action: .setGroupName(.moveToSelectKeyword(groupName, isFromGetStarted)))):
        state.routes.push(.selectKeyword(.init(groupName: groupName, isFromGetStarted: isFromGetStarted)))
        
      case let .router(.routeAction(id: _, action: .selectKeyword(.moveToSelectGroupPhoto(groupName, selectedKeyword, isFromGetStarted)))):
        state.routes.push(.selectGroupPhoto(.init(groupName: groupName, keyword: selectedKeyword, isFromGetStarted: isFromGetStarted)))
        
      case .router(.routeAction(id: _, action: .selectKeyword(.backToSetGroupName))):
        state.routes.pop()
        
      case let .router(.routeAction(id: _, action: .selectGroupPhoto(.moveToCreateGroupCompletion(createdGroupInfo, isFromGetStarted)))):
        state.routes.push(.createGroupCompletion(.init(createdGroupInfo: createdGroupInfo, isFromGetStarted: isFromGetStarted)))
        break
        
      case .router(.routeAction(id: _, action: .selectGroupPhoto(.backToSelectKeyword))):
        state.routes.pop()
        
      default:
        break
      }
      
      return .none
    }
    .forEachRoute(\.routes, action: \.router)
  }
}
