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
        state.routes.presentCover(.createGroupCoordinator(.init(routes: [.root(.setGroupName(.init(isFromGetStarted: false)), embedInNavigationView: true)])))
        
      case let .router(.routeAction(id: _, action: .home(.moveToCreateEvent(groupID)))):
        state.routes.push(.createEvent(.init(groupID: groupID)))
        
      case .router(.routeAction(id: _, action: .home(.moveToJoinGroup))):
        state.routes.push(.joinGroup(.init(isFromGetStarted: false)))
        
      case .router(.routeAction(id: _, action: .joinGroup(.backToHome))):
        state.routes.pop()
        
      case .router(.routeAction(id: _, action: .joinGroup(.backToGetStarted))):
        state.routes.pop()
        
      case .router(.routeAction(id: _, action: .joinGroup(.goToHome))):
        state.routes.push(.home(.init()))
        
      case .router(.routeAction(id: _, action: .createGroupCoordinator(.router(.routeAction(id: _, action: .setGroupName(.backToHome)))))):
        state.routes.dismiss()
        
      case .router(.routeAction(id: _, action: .createGroupCoordinator(.router(.routeAction(id: _, action: .setGroupName(.backToGetStarted)))))):
        state.routes.pop()
        
      case .router(.routeAction(id: _, action: .createGroupCoordinator(.router(.routeAction(id: _, action: .createGroupCompletion(.backToHome)))))):
        state.routes.dismiss()
        
      case .router(.routeAction(id: _, action: .createGroupCoordinator(.router(.routeAction(id: _, action: .createGroupCompletion(.goToHome)))))):
        state.routes.push(.home(.init()))
        
      case let .router(.routeAction(id: _, action: .home(.moveToVote(eventID)))):
        state.routes.push(.groupDetailCoordinator(.init(routes: [.root(.vote(.init(eventID: eventID, isFromMain: true)))])))
        
      case let .router(.routeAction(id: _, action: .groupDetailCoordinator(.router(.routeAction(id: _, action: .vote(.moveToVoteCompleteFromMain(voteCompleteInfo, isFromMain))))))):
        state.routes.push(.groupDetailCoordinator(.init(routes: [.root(.voteComplete(.init(voteResult: voteCompleteInfo, isFromMain: isFromMain)))])))
        
      case let .router(.routeAction(id: _, action: .home(.moveToGroupDetail(groupID)))):
        state.routes.push(.groupDetailCoordinator(.init(routes: [.root(.groupDetail(.init(groupID: groupID)))])))

      case .router(.routeAction(id: _, action: .groupDetailCoordinator(.router(.routeAction(id: _, action: .vote(.backToMainView)))))):
        state.routes.pop()
        
      case .router(.routeAction(id: _, action: .groupDetailCoordinator(.router(.routeAction(id: _, action: .voteComplete(.backToMain)))))):
        state.routes.pop(2)
        
      case .router(.routeAction(id: _, action: .groupDetailCoordinator(.router(.routeAction(id: _, action: .groupDetail(.backToHome)))))):
        state.routes.pop()
        
      case .router(.routeAction(id: _, action: .createEvent(.moveToHome))):
        state.routes.pop()
        
      case .router(.routeAction(id: _, action: .createEvent(.moveToHomeWithEvent))):
        state.routes.pop()
        
      case .router(.routeAction(id: _, action: .getStarted(.moveToJoinGroup))):
        state.routes.push(.joinGroup(.init(isFromGetStarted: true)))
        
      case .router(.routeAction(id: _, action: .getStarted(.moveToSetGroupName))):
        state.routes.push(.createGroupCoordinator(.init(routes: [.root(.setGroupName(.init(isFromGetStarted: true)), embedInNavigationView: true)])))
        
      default:
        break
      }
      
      return .none
    }
    .forEachRoute(\.routes, action: \.router)
  }
}
