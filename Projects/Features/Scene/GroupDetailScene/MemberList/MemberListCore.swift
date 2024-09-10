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
      userInfo: @autoclosure () -> UserInfo = .defaultValue
    ) {
      self.groupID = groupID
      self.memberList = memberList
      self.groupKeyword = groupKeyword
      self.toastPresented = toastPresented
      self.toastType = toastType
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
    
    // Internal Action
    case getMemberList(Result<MemberList, Error>)
    case showToast(MemberListToastType)
    
    // Route Action
    case backToGroupDetail
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
      }
    }
  }
}

extension MemberListCore {
  public enum MemberListToastType {
    case codeCopied
    
    var toast: ToastType {
      switch self {
      case .codeCopied:
        return .onlyText("그룹원 초대 코드가 복사됐습니다!")
      }
    }
  }
}
