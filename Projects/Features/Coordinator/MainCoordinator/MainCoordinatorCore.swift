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
      case .router(.routeAction(id: _, action: .groupList(.moveToMyPage))):
        state.routes.presentCover(.myPageCoordinator(.init(routes: [.root(.myPage(.init()), embedInNavigationView: true)])))
      default:
        break
      }
      
      return .none
    }
    .forEachRoute(\.routes, action: \.router)
  }
}
