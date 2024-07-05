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
    var showSheet: Bool

    public init(
      groupDetail: GroupDetail,
      showSheet: Bool = true
    ) {
      self.groupDetail = groupDetail
      self.showSheet = showSheet
    }
  }

  public enum Action: BindableAction {
    case binding(BindingAction<State>)
    case backButtonTapped
    case memberListButtonTapped
    case eventContainerViewButtonTapped(EventState)
  }

  public var body: some Reducer<State, Action> {
    BindingReducer()
    
    Reduce { state, action in
      switch action {
      case .backButtonTapped:
        return .none
      case .memberListButtonTapped:
        return .none
      case let .eventContainerViewButtonTapped(eventState):
        return .none
      case .binding:
        return .none
      }
    }
  }
}
