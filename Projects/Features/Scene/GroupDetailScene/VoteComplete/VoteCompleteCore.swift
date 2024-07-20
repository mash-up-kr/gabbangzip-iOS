//
//  VoteCompleteCore.swift
//  GroupDetail
//
//  Created by 최혜린 on 7/6/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import ComposableArchitecture

@Reducer
public struct VoteCompleteCore {
  public struct State: Equatable {

    public init() {
    }
  }

  public enum Action {
    case completeButtonTapped
  }

  public var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .completeButtonTapped:
        return .none
      }
    }
  }
}
