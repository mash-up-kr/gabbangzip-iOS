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
      case .router(.routeAction(id: _, action: .createGroupStart(.moveToSetGroupName))):
        state.routes.push(.setGroupName(.init()))
        
      case .router(.routeAction(id: _, action: .setGroupName(.moveToSelectKeyword))):
        state.routes.push(.selectKeyword(.init(groupName: "")))
        
      case .router(.routeAction(id: _, action: .setGroupName(.backToCreateGroupStart))):
        state.routes.pop()
        
      case .router(.routeAction(id: _, action: .selectKeyword(.moveToSelectGroupPhoto))):
        state.routes.push(.selectGroupPhoto(.init(groupName: "", keyword: .company)))
        
      case .router(.routeAction(id: _, action: .selectKeyword(.backToSetGroupName))):
        state.routes.pop()
        
      case .router(.routeAction(id: _, action: .selectGroupPhoto(.moveToCreateGroupCompletion))):
        // TODO: - 생성 완료 화면 구현되면 추가할 예정
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
