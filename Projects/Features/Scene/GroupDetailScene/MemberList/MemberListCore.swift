//
//  MemberListCore.swift
//  GroupDetail
//
//  Created by 최혜린 on 6/22/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import UIKit

import ComposableArchitecture

import Models

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
    case copyLinkButtonDidTap
    case backButtonDidTap
  }

  public var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .copyLinkButtonDidTap:
        // TODO: Client로 분리할 예정 ...ㅎㅎ
        UIPasteboard.general.string = state.inviteLink
        return .none
      case .backButtonDidTap:
        return .none
      }
    }
  }
}
