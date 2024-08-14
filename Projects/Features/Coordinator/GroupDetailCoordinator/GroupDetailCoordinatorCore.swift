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
      case let .router(.routeAction(id: _, action: .groupDetail(.moveToHistoryDetail(history, keyword, domain)))):
        state.routes.push(.historyDetail(.init(history: history, keyword: keyword, s3BucketDomain: domain)))
        
      case let .router(.routeAction(id: _, action: .groupDetail(.moveToMemberList(groupID)))):
        state.routes.push(.memberList(.init(groupID: groupID)))
        
      case let .router(.routeAction(id: _, action: .groupDetail(.moveToVote(eventID)))):
        state.routes.presentCover(.vote(.init(eventID: eventID)), embedInNavigationView: true)
        
      case .router(.routeAction(id: _, action: .historyDetail(.backToGroupDetail))):
        state.routes.pop()
        
      case .router(.routeAction(id: _, action: .memberList(.backToGroupDetail))):
        state.routes.pop()
        
      case .router(.routeAction(id: _, action: .vote(.dismissVoteView))):
        state.routes.dismiss()
        
      case let .router(.routeAction(id: _, action: .vote(.moveToVoteComplete(voteCompleteInfo)))):
        state.routes.push(.voteComplete(.init(voteResult: voteCompleteInfo)))
        
      case .router(.routeAction(id: _, action: .voteComplete(.backToGroupDetail))):
        state.routes.dismiss()
        
      default:
        break
      }
      
      return .none
    }
    .forEachRoute(\.routes, action: \.router)
  }
}

