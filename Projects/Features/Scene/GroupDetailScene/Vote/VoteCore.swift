//
//  VoteCore.swift
//  GroupDetail
//
//  Created by hyerin on 7/18/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import ComposableArchitecture
import Foundation

@Reducer
public struct VoteCore {
  
  public init() {}

  @ObservableState
  public struct State: Equatable {
    public var name: String
    public var voteButtonState: VoteButtonState
    public var passsButtonState: VoteButtonState
    
    public init(
      name: String,
      voteButtonState: VoteButtonState,
      passsButtonState: VoteButtonState
    ) {
      self.name = name
      self.voteButtonState = voteButtonState
      self.passsButtonState = passsButtonState
    }
  }

  public enum Action: BindableAction {
    case binding(BindingAction<State>)
    case passButtonTapped
    case voteButtonTapped
    case activatePassButton
    case activateVoteButton
    case resetButtonState
  }

  public var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .binding:
        return .none
      case .passButtonTapped:
        return .run { send in
          await send(.activatePassButton)
          
          DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            send(.resetButtonState)
          }
        }
      case .voteButtonTapped:
        return .run { send in
          await send(.activatePassButton)
          
          DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            send(.resetButtonState)
          }
        }
      case .activatePassButton:
        state.passsButtonState = .activate
        state.voteButtonState = .deactivate
        return .none
      case .activateVoteButton:
        state.voteButtonState = .activate
        state.passsButtonState = .deactivate
        return .none
      case .resetButtonState:
        state.passsButtonState = .defaultState
        state.voteButtonState = .defaultState
        return .none
      }
    }
  }
}
