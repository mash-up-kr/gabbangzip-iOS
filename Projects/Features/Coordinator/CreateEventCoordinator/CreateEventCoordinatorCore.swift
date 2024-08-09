//
//  CreateEventCoordinatorCore.swift
//  CreateEventCoordinator
//
//  Created by Hyun A Song on 8/8/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import ComposableArchitecture
import TCACoordinators

@Reducer
public struct CreateEventCoordinatorCore {
  public init() {}
  
  @ObservableState
  public struct State: Equatable {
    var routes: [Route<CreateEventScreen.State>]
    
    public init(routes: [Route<CreateEventScreen.State>]) {
      self.routes = routes
    }
  }
  
  public enum Action {
    case router(IndexedRouterActionOf<CreateEventScreen>)
  }
  
  public var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .router(.routeAction(id: _, action: .createEventStart(.moveToCreateEventProcess))):
        state.routes.push(.moveToCreateEventProcess(.init()))
        
      case .router(.routeAction(id: _, action: .createEventStart(.moveToGroupList))):
        state.routes.push(.moveToGroupList(.init()))
        
      case .router(.routeAction(id: _, action: .createEventStart(.moveToGroupMemberList))):
        state.routes.push(.moveToGroupMemberList(.init()))
        
      case .router(.routeAction(id: _, action: .moveToGroupMemberList(.moveBackToEvent))):
        state.routes.pop()
        
      case .router(.routeAction(id: _, action: .moveToCreateEventProcess(.moveToEventStart))):
        state.routes.pop()
        
      case .router(.routeAction(id: _, action: .moveToCreateEventProcess(.moveToGroupListWithEvent))):
        state.routes.push(.moveToGroupList(.init()))
        
      default:
        break
      }
      
      return .none
    }
    .forEachRoute(\.routes, action: \.router)
  }
}
