//
//  HistoryDetailCore.swift
//  GroupDetail
//
//  Created by 최혜린 on 7/6/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import ComposableArchitecture
import Models

@Reducer
public struct HistoryDetailCore {
  @ObservableState
  public struct State: Equatable {
    var history: History
    
    public init(history: History) {
      self.history = history
    }
  }

  public enum Action {
    case backButtonTapped
  }

  public var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .backButtonTapped:
        return .none
      }
    }
  }
}
