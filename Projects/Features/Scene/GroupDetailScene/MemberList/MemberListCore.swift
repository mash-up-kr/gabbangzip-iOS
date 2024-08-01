//
//  MemberListCore.swift
//  GroupDetail
//
//  Created by 최혜린 on 6/22/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import ComposableArchitecture
import Models
import Services
import UIKit

@Reducer
public struct MemberListCore {
  @ObservableState
  public struct State: Equatable {
    var memberList: MemberList
    var inviteLink: String
    var groupCategory: GroupCategory
    
    public init(
      memberList: MemberList,
      inviteLink: String,
      groupCategory: GroupCategory
    ) {
      self.memberList = memberList
      self.inviteLink = inviteLink
      self.groupCategory = groupCategory
    }
  }

  public enum Action {
    case copyLinkButtonTapped
    case backButtonTapped
  }
  
  @Dependency(\.uiPasteBoardClient) var uiPasteBoardClient

  public var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .copyLinkButtonTapped:
        return .run { [state] send in
          uiPasteBoardClient.copyTextToClipboard(state.inviteLink)
        }
      case .backButtonTapped:
        return .none
      }
    }
  }
}
