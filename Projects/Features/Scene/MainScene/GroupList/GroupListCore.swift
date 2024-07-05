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
    case onAppear
    case createEventButtonTapped
    case picButtonTapped
    case nudgeButtonTapped
    case voteButtonTapped
    case groupHeaderButtonTapped
    case createGroupButtonTapped
    case myPageButtonTapped
    case getGroupsResponse(Result<BaseResponse<GroupsData>, Error>)
  }
  
  @Dependency(\.groupAPIClient) var groupAPIClient

  public var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .onAppear:
        return .run { send in
          await send(.getGroupsResponse(Result { try await self.groupAPIClient.getGroups(accessToken: "") }))
        }
        
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
        return .none
        
      case let .getGroupsResponse(.success(response)):
        state.groups = response.data.groups
        return .none
        
      case .getGroupsResponse(.failure):
        // TODO: - 서버의 에러 메시지 형식 및 에러 수집 방식에 대한 논의 후 수정
        return .none
      }
    }
  }
}
