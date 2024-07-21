//
//  EventDetailCore.swift
//  GroupDetail
//
//  Created by 최혜린 on 7/6/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import ComposableArchitecture
import Models

@Reducer
public struct EventDetailCore {
  @ObservableState
  public struct State: Equatable {
    var eventDetail: EventDetail
    
    public init(
      eventDetail: EventDetail
    ) {
      self.eventDetail = eventDetail
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
