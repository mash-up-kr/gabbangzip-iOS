//
//  GroupDetailCore.swift
//  GroupDetail
//
//  Created by 최혜린 on 6/29/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import ComposableArchitecture

import Models

@Reducer
public struct GroupDetailCore {
  @ObservableState
  public struct State: Equatable {
    var groupDetail: GroupDetail

    public init(
      groupDetail: GroupDetail
    ) {
      self.groupDetail = groupDetail
    }
  }

  public enum Action {
    case backButtonDidTap
    case memberListButtonDidTap
    case eventContainerViewButtonDidTap(EventState)
  }

  public var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .backButtonDidTap:
        return .none
      case .memberListButtonDidTap:
        return .none
      case let .eventContainerViewButtonDidTap(state):
        return .none
      }
    }
  }
}
