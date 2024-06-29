//
//  EventContainerCore.swift
//  GroupDetail
//
//  Created by 최혜린 on 6/29/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import ComposableArchitecture

import Models

@Reducer
public struct EventContainerCore {
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
    case buttonDidTap(EventState)
  }

  public var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case let .buttonDidTap(eventState):
        print("eventState: \(eventState)")
        return .none
      }
    }
  }
}
