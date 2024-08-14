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

@Reducer
public struct HomeCore {
  public init() {}
  
  @ObservableState
  public struct State: Equatable {
    var groups: IdentifiedArrayOf<GroupCore.State>
    @Shared var userInfo: UserInfo
    @Shared var isHomeUpdated: Bool
    var floatingButtonExpanded: Bool
    var toastPresented: Bool
    var toastType: ToastType
    
    public init(
      groups: IdentifiedArrayOf<GroupCore.State> = [],
      userInfo: @autoclosure () -> UserInfo = .defaultValue,
      isHomeUpdated: @autoclosure () -> Bool = false,
      floatingButtonExpanded: Bool = false,
      toastPresented: Bool = false,
      toastType: ToastType = .onlyText("")
    ) {
      self.groups = groups
      self._userInfo = Shared(wrappedValue: userInfo(), .inMemory("userInfo"))
      self._isHomeUpdated = Shared(wrappedValue: isHomeUpdated(), .inMemory("isHomeUpdated"))
      self.floatingButtonExpanded = floatingButtonExpanded
      self.toastPresented = toastPresented
      self.toastType = toastType
    }
  }

  public enum Action {
    // View Action
    case onAppear
    case joinGroupButtonTapped
    case createGroupButtonTapped
    case myPageButtonTapped
    case toastPresentedChanged(Bool)
    
    // Internal Action
    case fetchGroups
    case getGroupsResponse(Result<GroupsData, Error>)
    case getS3BucketDomain(Result<String?, Error>)
    case floatingButtonExpandedChanged(Bool)
    case isHomeUpdatedChanged(Bool)
    case showToastMessage(ToastType)
    
    // Child Action
    case groups(IdentifiedActionOf<GroupCore>)
    
    // Route Action
    case moveToMyPage
    case moveToCreateGroup
    case moveToJoinGroup
    case moveToGroupDetail(Int)
    case moveToCreateEvent
    case moveToVote
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
            state.$isHomeUpdated.publisher
              .map(Action.isHomeUpdatedChanged)
          }
        ])
        
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
        state.groups = IdentifiedArray(
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
        return .none
        
      case .getGroupsResponse(.failure):
        // TODO: - 서버의 에러 메시지 형식 및 에러 수집 방식에 대한 논의 후 수정
        return .none
        
      case let .getS3BucketDomain(.success(domain)):
        if let domain {
          for i in state.groups.indices {
            state.groups[i].s3BucketDomain = domain
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
        
      case let .groups(.element(id: _, action: .delegate(delegate))):
        return .run { send in
          switch delegate {
          case let .headerButtonTapped(groupID):
            await send(.moveToGroupDetail(groupID))
          case .createEventButtonTapped:
            await send(.moveToCreateEvent)
          case .stabbingSuccessed:
            await send(.showToastMessage(.textWithCheckIcon("쿡찌르기 성공!")))
          case .stabbingFailed:
            await send(.showToastMessage(.textWithInfoIcon("쿡찌르기 실패!")))
          case .imageUploadSuccessed:
            await send(.showToastMessage(.textWithCheckIcon("이미지 업로드 성공!")))
            await send(.fetchGroups)
          case .imageUploadFailed:
            await send(.showToastMessage(.textWithInfoIcon("이미지 업로드 실패!")))
          case .selectPICButtonTapped:
            await send(.moveToVote)
          }
        }
        
      case .groups:
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
    .forEach(\.groups, action: \.groups) {
      GroupCore()
    }
  }
}
