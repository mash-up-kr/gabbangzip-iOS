//
//  MainCoordinatorCore.swift
//  MainCoordinator
//
//  Created by YangJoonHyeok on 7/21/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import ComposableArchitecture
import TCACoordinators

@Reducer
public struct MainCoordinatorCore {
  public init() {}
  
  @ObservableState
  public struct State: Equatable {
    var routes: [Route<MainScreen.State>]
    
    public init(routes: [Route<MainScreen.State>]) {
      self.routes = routes
    }
  }
  
  public enum Action {
    case router(IndexedRouterActionOf<MainScreen>)
  }
  
  public var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .router(.routeAction(id: _, action: .home(.moveToMyPage))):
        state.routes.push(.myPage(.init()))
        
      case .router(.routeAction(id: _, action: .myPage(.backToHome))):
        state.routes.pop()
        
      case .router(.routeAction(id: _, action: .home(.moveToCreateGroup))):
        state.routes.presentCover(.createGroupCoordinator(.init(routes: [.root(.createGroupStart(.init()), embedInNavigationView: true)])))
        
      case .router(.routeAction(id: _, action: .home(.moveToJoinGroup))):
        state.routes.push(.joinGroup(.init()))
        
      case .router(.routeAction(id: _, action: .groupList(.moveToEvent))):
        state.routes.presentCover(.createEventCoordinator(.init(routes: [.root(.createEventStart(.init()), embedInNavigationView: true)])))
        
      case .router(.routeAction(id: _, action: .joinGroup(.backToGroupList))):
        state.routes.pop()
        
      case .router(.routeAction(id: _, action: .createGroupCoordinator(.router(.routeAction(id: _, action: .createGroupCompletion(.backToHome)))))):
        state.routes.dismiss()
        
      case let .router(.routeAction(id: _, action: .home(.moveToGroupDetail(groupID)))):
        state.routes.push(.groupDetailCoordinator(.init(routes: [.root(.groupDetail(.init(groupID: groupID)))])))
        
      case .router(.routeAction(id: _, action: .groupDetailCoordinator(.router(.routeAction(id: _, action: .groupDetail(.backToHome)))))):
        state.routes.pop()
        
      default:
        break
      }
      
      return .none
    }
    .forEachRoute(\.routes, action: \.router)
  }
}
