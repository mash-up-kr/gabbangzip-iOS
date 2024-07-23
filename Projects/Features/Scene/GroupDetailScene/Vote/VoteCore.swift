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
    public var swipeDirection: SwipeDirection?
    public var isClosePopupPresented: Bool
    
    public init(
      name: String,
      voteButtonState: VoteButtonState,
      passsButtonState: VoteButtonState,
      imageURLs: [URL?],
      pickedImageIndex: [Int],
      swipeDirection: SwipeDirection?,
      showClosePopup: Bool
    ) {
      self.name = name
      self.voteButtonState = voteButtonState
      self.passsButtonState = passsButtonState
      self.imageURLs = imageURLs
      self.pickedImageIndex = pickedImageIndex
      self.swipeDirection = swipeDirection
      self.isClosePopupPresented = showClosePopup
    }
  }

  public enum Action: BindableAction {
    case binding(BindingAction<State>)
    
    // View Action
    case passButtonTapped
    case voteButtonTapped
    case cardSwiped(Int, SwipeDirection)
    case closeButtonTapped
    case exitButtonTapped
    case continueButtonTapped
    
    // Internal Action
    case activatePassButton
    case activateVoteButton
    case resetButtonState
    case voteEnded
    
    // Route Action
  }

  public var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .binding:
        return .none
        
      case .passButtonTapped:
        state.swipeDirection = .left
        return .run { send in
          await send(.activatePassButton)
          
          DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            send(.resetButtonState)
          }
        }
        
      case .voteButtonTapped:
        state.swipeDirection = .right
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
        // TODO: 이 부분 로직 API 붙이면서 수정할 예정입니다
        state.imageURLs.remove(at: index)
        
        if direction == .right {
          state.pickedImageIndex.append(index)
        }
        
        if state.imageURLs.isEmpty {
          return .send(.voteEnded)
        } else {
          return .none
        }
        
      case .voteEnded:
        return .none
        
      case .closeButtonTapped:
        state.isClosePopupPresented = true
        return .none
        
      case .exitButtonTapped:
        state.isClosePopupPresented = false
        return .none
        
      case .continueButtonTapped:
        state.isClosePopupPresented = false
        return .none
      }
    }
  }
}
