//
//  VoteCore.swift
//  GroupDetail
//
//  Created by hyerin on 7/18/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import Common
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
    public var imageURLs: [URL?]
    public var pickedImageIndex: [Int]
    
    public init(
      name: String,
      voteButtonState: VoteButtonState,
      passsButtonState: VoteButtonState,
      imageURLs: [URL?],
      pickedImageIndex: [Int]
    ) {
      self.name = name
      self.voteButtonState = voteButtonState
      self.passsButtonState = passsButtonState
      self.imageURLs = imageURLs
      self.pickedImageIndex = pickedImageIndex
    }
  }

  public enum Action: BindableAction {
    case binding(BindingAction<State>)
    case passButtonTapped
    case voteButtonTapped
    case activatePassButton
    case activateVoteButton
    case resetButtonState
    case cardSwiped(Int, SwipeDirection)
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
      case let .cardSwiped(index, direction):
        state.imageURLs.remove(at: index)
        
        if direction == .right {
          state.pickedImageIndex.append(index)
        }
        
        return .none
      }
    }
  }
}
