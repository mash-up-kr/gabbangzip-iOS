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
    @Shared var userInfo: UserInfo
    @Shared var isGroupListUpdated: Bool
    var s3BucketDomain: String
    var floatingButtonExpanded: Bool
    
    public init(
      groups: [GroupData] = [],
      userInfo: @autoclosure () -> UserInfo = .defaultValue,
      isGroupListUpdated: @autoclosure () -> Bool = false,
      s3BucketDomain: String = "",
      floatingButtonExpanded: Bool = false
    ) {
      self.groups = groups
      self._userInfo = Shared(wrappedValue: userInfo(), .inMemory("userInfo"))
      self._isGroupListUpdated = Shared(wrappedValue: isGroupListUpdated(), .inMemory("isGroupListUpdated"))
      self.s3BucketDomain = s3BucketDomain
      self.floatingButtonExpanded = floatingButtonExpanded
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
    case joinGroupButtonTapped
    case createGroupButtonTapped
    case myPageButtonTapped
    
    // Internal Action
    case fetchGroups
    case getGroupsResponse(Result<GroupsData, Error>)
    case getS3BucketDomain(Result<String?, Error>)
    case setS3BucketDomain(String)
    case floatingButtonExpandedChanged(Bool)
    case isGroupListUpdatedChanged(Bool)
    
    // Route Action
    case moveToMyPage
    case moveToCreateGroup
    case moveToJoinGroup
  }
  
  @Dependency(\.groupAPIClient) var groupAPIClient
  @Dependency(\.keyChainClient) var keyChainClient
  @Dependency(\.bundleClient) var bundleClient

  public var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .onAppear:
        return .concatenate([
          Effect.send(.fetchGroups),
          Effect.publisher {
            state.$isGroupListUpdated.publisher
              .map(Action.isGroupListUpdatedChanged)
          }
        ])
        
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
        
      case .joinGroupButtonTapped:
        state.floatingButtonExpanded = false
        return .send(.moveToJoinGroup)
        
      case .createGroupButtonTapped:
        state.floatingButtonExpanded = false
        return .send(.moveToCreateGroup)
        
      case .myPageButtonTapped:
        return .send(.moveToMyPage)
        
      case .fetchGroups:
        state.isGroupListUpdated = false
        return .run(
          operation: { [state] send in
            await send(.getGroupsResponse(Result {
              try await self.groupAPIClient.getGroups(accessToken: state.userInfo.accessToken)
            }))
            await send(.getS3BucketDomain(Result {
              try bundleClient.getValue(key: "S3BucketDomain") as? String
            }))
          },
          catch: { error, send in
          }
        )
        
      case let .getGroupsResponse(.success(groupsData)):
        state.groups = groupsData.groups
        return .none
        
      case .getGroupsResponse(.failure):
        // TODO: - 서버의 에러 메시지 형식 및 에러 수집 방식에 대한 논의 후 수정
        return .none
        
      case let .getS3BucketDomain(.success(domain)):
        if let domain {
          state.s3BucketDomain = domain
        }
        return .none
        
      case .getS3BucketDomain(.failure):
        return .none
        
      case let .setS3BucketDomain(domain):
        state.s3BucketDomain = domain
        return .none
        
      case let .floatingButtonExpandedChanged(value):
        state.floatingButtonExpanded = value
        return .none
        
      case let .isGroupListUpdatedChanged(isGroupListUpdated):
        return .run { send in
          if isGroupListUpdated {
            await send(.fetchGroups)
          }
        }
        
      case .moveToMyPage:
        return .none
        
      case .moveToCreateGroup:
        return .none
        
      case .moveToJoinGroup:
        return .none
      }
    }
  }
}
