//
//  GroupListCore.swift
//  Main
//
//  Created by YangJoonHyeok on 7/2/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import ComposableArchitecture
import Models
import Services

@Reducer
public struct GroupListCore {
  public init() {}
  
  @ObservableState
  public struct State: Equatable {
    var groups: [GroupData]
    
    public init(
      groups: [GroupData] = []
    ) {
      self.groups = groups
    }
  }

  public enum Action {
    // View Action
    case onAppear
    case createEventButtonTapped
    case picButtonTapped
    case nudgeButtonTapped
    case voteButtonTapped
    case groupHeaderButtonTapped
    case createGroupButtonTapped
    case myPageButtonTapped
    
    // Internal Action
    case getGroupsResponse(Result<GroupsData, Error>)
    
    // Route Action
    case moveToMyPage
  }
  
  @Dependency(\.groupAPIClient) var groupAPIClient
  @Dependency(\.keyChainClient) var keyChainClient

  public var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .onAppear:
        return .run (
          operation: { send in
            let userInfo = try await keyChainClient.readUserInfo()
            await send(.getGroupsResponse(Result { try await self.groupAPIClient.getGroups(accessToken: userInfo.accessToken) }))
          },
          catch: { error, send in
          }
        )
        
      case .createEventButtonTapped:
        return .none
        
      case .picButtonTapped:
        return .none
        
      case .nudgeButtonTapped:
        return .none
        
      case .voteButtonTapped:
        return .none
        
      case .groupHeaderButtonTapped:
        return .none
        
      case .createGroupButtonTapped:
        return .none
        
      case .myPageButtonTapped:
        return .send(.moveToMyPage)
        
      case let .getGroupsResponse(.success(groupsData)):
        state.groups = groupsData.groups
        return .none
        
      case .getGroupsResponse(.failure):
        // TODO: - 서버의 에러 메시지 형식 및 에러 수집 방식에 대한 논의 후 수정
        return .none
        
      case .moveToMyPage:
        return .none
      }
    }
  }
}
