//
//  HomeCore.swift
//  Main
//
//  Created by YangJoonHyeok on 7/2/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import ComposableArchitecture
import DesignSystem
import Models
import Services

public enum DisplayMode {
  case list
  case grid
}

@Reducer
public struct HomeCore {
  public init() {}
  
  @ObservableState
  public struct State: Equatable {
    @Shared var userInfo: UserInfo
    @Shared var isHomeUpdated: Bool
    var floatingButtonExpanded: Bool
    var toastPresented: Bool
    var toastType: ToastType
    var displayMode: DisplayMode
    var groupList: GroupListCore.State
    var groupGrid: GroupGridCore.State
    
    public init(
      userInfo: @autoclosure () -> UserInfo = .defaultValue,
      isHomeUpdated: @autoclosure () -> Bool = false,
      floatingButtonExpanded: Bool = false,
      toastPresented: Bool = false,
      toastType: ToastType = .onlyText(""),
      displayMode: DisplayMode = .list,
      groupList: GroupListCore.State = .init(),
      groupGrid: GroupGridCore.State = .init()
    ) {
      self._userInfo = Shared(wrappedValue: userInfo(), .inMemory("userInfo"))
      self._isHomeUpdated = Shared(wrappedValue: isHomeUpdated(), .inMemory("isHomeUpdated"))
      self.floatingButtonExpanded = floatingButtonExpanded
      self.toastPresented = toastPresented
      self.toastType = toastType
      self.displayMode = displayMode
      self.groupList = groupList
      self.groupGrid = groupGrid
    }
  }

  public enum Action {
    // View Action
    case onAppear
    case screenTapped
    case joinGroupButtonTapped
    case createGroupButtonTapped
    case myPageButtonTapped
    case toastPresentedChanged(Bool)
    case displayModeChanged(DisplayMode)
    
    // Internal Action
    case fetchGroups
    case getGroupsResponse(Result<GroupsData, Error>)
    case getS3BucketDomain(Result<String?, Error>)
    case floatingButtonExpandedChanged(Bool)
    case isHomeUpdatedChanged(Bool)
    case showToastMessage(ToastType)
    case setFloatingButtonExpanded(Bool)
    
    // Child Action
    case groupList(GroupListCore.Action)
    case groupGrid(GroupGridCore.Action)
    
    // Route Action
    case moveToMyPage
    case moveToCreateGroup
    case moveToJoinGroup
    case moveToGroupDetail(Int)
    case moveToCreateEvent(Int)
    case moveToVote(Int)
  }
  
  @Dependency(\.groupAPIClient) var groupAPIClient
  @Dependency(\.keyChainClient) var keyChainClient
  @Dependency(\.bundleClient) var bundleClient

  public var body: some Reducer<State, Action> {
    Scope(state: \.groupList, action: \.groupList) {
      GroupListCore()
    }
    
    Scope(state: \.groupGrid, action: \.groupGrid) {
      GroupGridCore()
    }
    
    Reduce { state, action in
      switch action {
      case .onAppear:
        return .concatenate([
          Effect.send(.fetchGroups),
          Effect.publisher {
            state.$isHomeUpdated.publisher
              .map(Action.isHomeUpdatedChanged)
          }
        ])
        
      case .screenTapped:
        return .run { send in
          await send(.setFloatingButtonExpanded(false))
        }
        .animation(.default)
        
      case .joinGroupButtonTapped:
        state.floatingButtonExpanded = false
        return .send(.moveToJoinGroup)
        
      case .createGroupButtonTapped:
        state.floatingButtonExpanded = false
        return .send(.moveToCreateGroup)
        
      case .myPageButtonTapped:
        return .send(.moveToMyPage)
        
      case let .toastPresentedChanged(value):
        state.toastPresented = value
        return .none
        
      case let .displayModeChanged(displayMode):
        state.displayMode = displayMode
        return .none
        
      case .fetchGroups:
        state.isHomeUpdated = false
        return .run { [state] send in
          await send(.getGroupsResponse(Result {
            try await self.groupAPIClient.getGroups(state.userInfo.accessToken)
          }))
          await send(.getS3BucketDomain(Result {
            try bundleClient.getValue("S3BucketDomain") as? String
          }))
        }
        
      case let .getGroupsResponse(.success(groupsData)):
        state.groupList.groups = IdentifiedArray(
          uniqueElements: groupsData.groups
            .enumerated()
            .map { index, group in
              GroupCore.State(
                userInfo: state.$userInfo,
                id: group.id,
                name: group.name,
                keyword: group.keyword,
                status: group.status,
                statusDescription: group.statusDescription,
                recentEvent: group.recentEvent,
                cardFrontImageURL: group.cardFrontImageURL,
                cardBackImages: group.cardBackImages,
                isLast: index == groupsData.groups.count - 1
              )
            }
        )
        
        state.groupGrid.groupGridItems = IdentifiedArray(
          uniqueElements: groupsData.groups.map {
            GroupGridItemCore.State(
              id: $0.id,
              name: $0.name,
              keyword: $0.keyword,
              statusDescription: $0.statusDescription,
              cardFrontImageURL: $0.cardFrontImageURL
            )
          }
        )
        return .none
        
      case .getGroupsResponse(.failure):
        // TODO: - 서버의 에러 메시지 형식 및 에러 수집 방식에 대한 논의 후 수정
        return .none
        
      case let .getS3BucketDomain(.success(domain)):
        if let domain {
          for i in state.groupList.groups.indices {
            state.groupList.groups[i].s3BucketDomain = domain
            state.groupGrid.groupGridItems[i].s3BucketDomain = domain
          }
        }
        return .none
        
      case .getS3BucketDomain(.failure):
        return .none
        
      case let .floatingButtonExpandedChanged(value):
        state.floatingButtonExpanded = value
        return .none
        
      case let .isHomeUpdatedChanged(isHomeUpdated):
        return .run { send in
          if isHomeUpdated {
            await send(.fetchGroups)
          }
        }
        
      case let .showToastMessage(toastType):
        state.toastType = toastType
        state.toastPresented = true
        return .none
        
      case let .setFloatingButtonExpanded(value):
        state.floatingButtonExpanded = value
        return .none
        
      case let .groupList(.delegate(action)):
        return .run { send in
          switch action {
          case let .moveToGroupDetail(groupID):
            await send(.moveToGroupDetail(groupID))
          case let .moveToCreateEvent(groupID):
            await send(.moveToCreateEvent(groupID))
          case let .showToastMessage(toastType):
            await send(.showToastMessage(toastType))
          case .fetchGroups:
            await send(.fetchGroups)
          case let .moveToVote(eventID):
            await send(.moveToVote(eventID))
          }
        }
        
      case .groupList:
        return .none
        
      case .groupGrid:
        return .none
        
      case .moveToMyPage:
        return .none
        
      case .moveToCreateGroup:
        return .none
        
      case .moveToJoinGroup:
        return .none
        
      case .moveToGroupDetail:
        return .none
        
      case .moveToCreateEvent:
        return .none
        
      case .moveToVote:
        return .none
      }
    }
  }
}
