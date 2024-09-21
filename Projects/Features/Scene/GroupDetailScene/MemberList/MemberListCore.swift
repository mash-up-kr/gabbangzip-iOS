//
//  MemberListCore.swift
//  GroupDetail
//
//  Created by 최혜린 on 6/22/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import ComposableArchitecture
import DesignSystem
import Models
import Services

@Reducer
public struct MemberListCore {
  public init() {}
  
  @ObservableState
  public struct State: Equatable {
    var groupID: Int
    var memberList: MemberList?
    var groupKeyword: GroupData.Keyword
    var toastPresented: Bool
    var toastType: MemberListToastType
    var popupPresented: Bool
    var isFullCapacity: Bool {
      memberList?.members.count == 6
    }
    var inviteMemberMessage: String {
      isFullCapacity ? "그룹 최대 인원은 6명이에요." : "그룹원을 추가하고 싶으세요?"
    }
    @Shared var userInfo: UserInfo
    
    public init(
      groupID: Int,
      memberList: MemberList? = nil,
      groupKeyword: GroupData.Keyword,
      toastPresented: Bool = false,
      toastType: MemberListToastType = .codeCopied,
      popupPresented: Bool = false,
      userInfo: @autoclosure () -> UserInfo = .defaultValue
    ) {
      self.groupID = groupID
      self.memberList = memberList
      self.groupKeyword = groupKeyword
      self.toastPresented = toastPresented
      self.toastType = toastType
      self.popupPresented = popupPresented
      self._userInfo = Shared(wrappedValue: userInfo(), .inMemory("userInfo"))
    }
  }
  
  @Dependency(\.groupAPIClient) var groupAPIClient

  public enum Action: BindableAction {
    case binding(BindingAction<State>)
    
    // View Action
    case onAppear
    case copyCodeButtonTapped
    case backButtonTapped
    case leaveGroupButtonTapped
    case popupLeftButtonTapped
    case popupRightButtonTapped
    
    // Internal Action
    case getMemberList(Result<MemberList, Error>)
    case showToast(MemberListToastType)
    case leaveGroupResponse(Result<GroupID, Error>)
    
    // Route Action
    case backToGroupDetail
    case backToHome
  }
  
  @Dependency(\.uiPasteBoardClient) var uiPasteBoardClient
  
  public var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .binding:
        return .none
        
      case .onAppear:
        return .run(
          operation: { [state] send in
            await send(.getMemberList(Result {
              try await self.groupAPIClient.getMemberList(accessToken: state.userInfo.accessToken, groupID: state.groupID)
            }))
          }
        )
        
      case .copyCodeButtonTapped:
        return .run { [state] send in
          uiPasteBoardClient.copyTextToClipboard(state.memberList?.invitationCode ?? "")
          await send(.showToast(.codeCopied))
        }
        
      case .backButtonTapped:
        return .send(.backToGroupDetail)
        
      case .leaveGroupButtonTapped:
        state.popupPresented = true
        return .none
        
      case .popupLeftButtonTapped:
        state.popupPresented = false
        return .run { [state] send in
          await send(.leaveGroupResponse(Result {
            try await self.groupAPIClient.leaveGroup(accessToken: state.userInfo.accessToken, groupID: state.groupID)
          }))
        }
        
      case .popupRightButtonTapped:
        state.popupPresented = false
        return .none
        
      case let .getMemberList(.success(memberList)):
        state.memberList = memberList
        return .none
        
      case .getMemberList(.failure):
        return .none
        
      case .backToGroupDetail:
        return .none
        
      case let .showToast(toastType):
        state.toastPresented = true
        state.toastType = toastType
        return .none
        
      case .leaveGroupResponse(.success):
        return .send(.backToHome)
        
      case let .leaveGroupResponse(.failure(error)):
        return .run { send in
          if let error = error as? GroupAPIClientError,
             let networkManagerError = error.underlying as? NetworkManagerError,
             let picError = networkManagerError.underlying as? NetworkManagerError,
             let response = picError.userInfo["message"] as? FailureResponse {
            await send(.showToast(.custom(response.errorResponse.message)))
          } else {
            await send(.showToast(.leaveGroupFailed))
          }
        }
        
      case .backToHome:
        return .none
      }
    }
  }
}

extension MemberListCore {
  public enum MemberListToastType: Equatable {
    case codeCopied
    case leaveGroupFailed
    case custom(String)
    
    var toast: ToastType {
      switch self {
      case .codeCopied:
        return .onlyText("그룹원 초대 코드가 복사됐습니다!")
      case .leaveGroupFailed:
        return .onlyText("그룹 나가기에 실패했습니다.")
      case let .custom(message):
        return .onlyText(message)
      }
    }
  }
}
