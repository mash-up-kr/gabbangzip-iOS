//
//  GroupDetailCore.swift
//  GroupDetail
//
//  Created by 최혜린 on 6/29/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import ComposableArchitecture
import Models
import Services

@Reducer
public struct GroupDetailCore {
  @ObservableState
  public struct State: Equatable {
    var groupID: Int
    var groupDetail: GroupDetailInfo
    var showSheet: Bool
    @Shared var userInfo: UserInfo

    public init(
      groupID: Int,
      groupDetail: GroupDetailInfo,
      showSheet: Bool = true,
      userInfo: @autoclosure () -> UserInfo = .defaultValue
    ) {
      self.groupID = groupID
      self.groupDetail = groupDetail
      self.showSheet = showSheet
      self._userInfo = Shared(wrappedValue: userInfo(), .inMemory("userInfo"))
    }
  }
  
  @Dependency(\.groupAPIClient) var groupAPIClient

  public enum Action: BindableAction {
    case binding(BindingAction<State>)
    
    // View Action
    case onAppear
    case backButtonTapped
    case memberListButtonTapped
    case eventContainerViewButtonTapped(GroupData.Status)

    // Internal Action
    case getGroupDetailResponse(Result<GroupDetailInfo, Error>)

    // Route Action
    case backToHome
    case moveToMemberList
    case moveToVote
  }

  public var body: some Reducer<State, Action> {
    BindingReducer()
    
    Reduce { state, action in
      switch action {
      case .binding:
        return .none
        
      case .onAppear:
        return .run(
          operation: { [state] send in
            await send(.getGroupDetailResponse(Result {
              try await self.groupAPIClient.getGroupDetail(accessToken: state.userInfo.accessToken, groupID: state.groupID)
            }))
          },
          catch: { error, send in }
        )
        
      case .backButtonTapped:
        return .send(.backToHome)
        
      case .memberListButtonTapped:
        return .send(.moveToMemberList)
        
      case let .eventContainerViewButtonTapped(status):
        switch status {
        case .beforeMyUpload:
          // 사진 업로드 화면 보여줘야함
          return .none
        case .beforeMyVote:
          return .send(.moveToVote)
        case .afterMyVote, .afterMyUpload:
          // 쿡 찌르기 API 호출
          return .none
        case .noPastAndCurrentEvent, .noCurrentEvent, .eventCompleted:
          return .none
        }
        
      case let .getGroupDetailResponse(.success(groupDetail)):
        state.groupDetail = groupDetail
        return .none
        
      case .getGroupDetailResponse(.failure):
        return .none
        
      case .backToHome:
        return .none
        
      case .moveToMemberList:
        return .none
        
      case .moveToVote:
        return .none
      }
    }
  }
}
