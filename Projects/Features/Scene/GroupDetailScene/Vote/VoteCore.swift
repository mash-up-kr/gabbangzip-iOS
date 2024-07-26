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
    public var passButtonState: VoteButtonState
    public var imageURLs: [URL?]
    public var imageCount: Int {
      imageURLs.count
    }
    // TODO: 네이밍 수정
    public var pickedImageIndex: [Int]
    public var swipeDirection: SwipeDirection
    public var isPopupPresented: Bool
    public var popupType: VotePopupType
    public var isVoteButtonDisabled: Bool
    
    public init(
      name: String,
      voteButtonState: VoteButtonState,
      passsButtonState: VoteButtonState,
      imageURLs: [URL?],
      pickedImageIndex: [Int],
      swipeDirection: SwipeDirection,
      isPopupPresented: Bool,
      popupType: VotePopupType,
      isVoteButtonDisabled: Bool
    ) {
      self.name = name
      self.voteButtonState = voteButtonState
      self.passButtonState = passsButtonState
      self.imageURLs = imageURLs
      self.pickedImageIndex = pickedImageIndex
      self.swipeDirection = swipeDirection
      self.isPopupPresented = isPopupPresented
      self.popupType = popupType
      self.isVoteButtonDisabled = isVoteButtonDisabled
    }
  }

  public enum VotePopupType {
    case close
    
    var title: String {
      switch self {
      case .close:
        return "나가실건가요?"
      }
    }
    
    var description: String {
      switch self {
      case .close:
        return "페이지를 나가면\n처음부터 다시 투표 하게돼요."
      }
    }
    
    var leftButtonTitle: String {
      switch self {
      case .close:
        return "나가기"
      }
    }
    
    var rightButtonTitle: String {
      switch self {
      case .close:
        "계속 투표하기"
      }
    }
  }

  public enum Action: BindableAction {
    case binding(BindingAction<State>)
    
    // View Action
    case passButtonTapped
    case voteButtonTapped
    case cardSwiped(Int, SwipeDirection)
    case exitButtonTapped
    case popupLeftButtonTapped
    case popupRightButtonTapped
    
    // Internal Action
    case resetButtonState
    case voteEnded
    case swipeCard(SwipeDirection)
    
    // Route Action
  }

  public var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .binding:
        return .none
        
      case .passButtonTapped:
        return .run { send in
          await send(.swipeCard(.left))
          
          DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            send(.resetButtonState)
          }
        }
        
      case .voteButtonTapped:
        return .run { send in
          await send(.swipeCard(.right))
          
          DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            send(.resetButtonState)
          }
        }
        
      case let .cardSwiped(index, direction):
        state.swipeDirection = .defaultState
        // TODO: 이 부분 로직 API 붙이면서 수정할 예정입니다
        state.imageURLs.remove(at: index)
        state.isVoteButtonDisabled = state.imageURLs.isEmpty
        
        if direction == .right {
          state.pickedImageIndex.append(index)
        }
        
        if state.imageURLs.isEmpty {
          return .send(.voteEnded)
        } else {
          return .none
        }
        
      case .exitButtonTapped:
        state.isPopupPresented = true
        return .none
        
      case .popupLeftButtonTapped:
        state.isPopupPresented = false
        return .none
        
      case .popupRightButtonTapped:
        state.isPopupPresented = false
        return .none
        
      case .resetButtonState:
        state.passButtonState = .defaultState
        state.voteButtonState = .defaultState
        return .none
        
      case .voteEnded:
        return .none
        
      case let .swipeCard(direction):
        state.swipeDirection = direction
        state.passButtonState = direction == .left ? .activate : .deactivate
        state.voteButtonState = direction == .left ? .deactivate : .activate
        return .none
      }
    }
  }
}
