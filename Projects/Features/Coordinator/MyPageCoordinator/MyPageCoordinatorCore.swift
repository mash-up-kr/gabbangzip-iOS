//
//  MyPageCoordinatorCore.swift
//  MyPageCoordinator
//
//  Created by YangJoonHyeok on 7/21/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import ComposableArchitecture
import TCACoordinators

@Reducer
public struct MyPageCoordinatorCore {
  public init() {}
  
  @ObservableState
  public struct State: Equatable {
    var routes: [Route<MyPageScreen.State>]
    
    public init(routes: [Route<MyPageScreen.State>]) {
      self.routes = routes
    }
  }
  
  public enum Action {
    case router(IndexedRouterActionOf<MyPageScreen>)
  }
  
  @Dependency(\.dismiss) var dismiss
  
  public var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .router(.routeAction(id: _, action: .myPage(.backToLogin))):
        return .run { send in
          await self.dismiss()
        }
        
      default:
        break
      }
      
      return .none
    }
    .forEachRoute(\.routes, action: \.router)
  }
}
