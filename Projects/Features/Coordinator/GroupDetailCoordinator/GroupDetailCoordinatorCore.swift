//
//  GroupDetailCoordinatorCore.swift
//  GroupDetailCoordinator
//
//  Created by hyerin on 8/12/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import ComposableArchitecture
import TCACoordinators

@Reducer
public struct GroupDetailCoordinatorCore {
  public init() {}
  
  @ObservableState
  public struct State: Equatable {
    var routes: [Route<GroupDetailScreen.State>]
    
    public init(routes: [Route<GroupDetailScreen.State>]) {
      self.routes = routes
    }
  }
  
  public enum Action {
    case router(IndexedRouterActionOf<GroupDetailScreen>)
  }
  
  public var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {

      }
    }
    .forEachRoute(\.routes, action: \.router)
  }
}

