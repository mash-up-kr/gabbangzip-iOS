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
import Models

@Reducer
public struct VoteCore {
  
  public init() {}

  @ObservableState
  public struct State: Equatable {
    @Shared var userInfo: UserInfo
    var voteButtonState: VoteButtonState
    var passButtonState: VoteButtonState
    var eventID: Int
    var voteOptions: [VoteOptionInfo]
    var imageCount: Int {
      voteOptions.count
    }
    var pickedImageIDs: [Int]
    var swipeDirection: SwipeDirection
    var isPopupPresented: Bool
    var popupType: VotePopupType
    var isVoteButtonDisabled: Bool
    
    public init(
      userInfo: @autoclosure () -> UserInfo = .defaultValue,
      voteButtonState: VoteButtonState,
      passsButtonState: VoteButtonState,
      eventID: Int,
      voteOptions: [VoteOptionInfo],
      pickedImageIDs: [Int],
      swipeDirection: SwipeDirection,
      isPopupPresented: Bool,
      popupType: VotePopupType,
      isVoteButtonDisabled: Bool
    ) {
      self._userInfo = Shared(wrappedValue: userInfo(), .inMemory("userInfo"))
      self.voteButtonState = voteButtonState
      self.passButtonState = passsButtonState
      self.eventID = eventID
      self.voteOptions = voteOptions
      self.pickedImageIDs = pickedImageIDs
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
    case onAppear
    case passButtonTapped
    case voteButtonTapped
    case cardSwiped(Int, SwipeDirection)
    case exitButtonTapped
    case popupLeftButtonTapped
    case popupRightButtonTapped
    
    // Internal Action
    case getVoteOptions(Result<[VoteOptionInfo], Error>)
    case postVoteResult(Result<VoteCompleteInfo, Error>)
    case resetButtonState
    case voteEnded
    case swipeCard(SwipeDirection)
    
    // Route Action
    case dismissVoteView
  }
  
  @Dependency(\.mainQueue) var mainQueue
  @Dependency(\.voteAPIClient) var voteAPIClient

  public var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .binding:
        return .none
        
      case .onAppear:
        return .run(
          operation: { [state] send in
            await send(.getVoteOptions(Result {
              try await self.voteAPIClient.getVoteOptions(state.userInfo.accessToken, state.eventID)
            }))
          }, catch: { error, send in
          
          }
        )
        
      case .passButtonTapped:
        return .run { send in
          await send(.swipeCard(.left))
          
          mainQueue.schedule(after: .init(.now() + 1.0)) {
            Task {
              await send(.resetButtonState)
            }
          }
        }
        
      case .voteButtonTapped:
        return .run { send in
          await send(.swipeCard(.right))
          
          mainQueue.schedule(after: .init(.now() + 1.0)) {
            Task {
              await send(.resetButtonState)
            }
          }
        }
        
      case let .cardSwiped(index, direction):
        state.swipeDirection = .defaultState
        // TODO: 이 부분 로직 API 붙이면서 수정할 예정입니다
        if let voteOption = state.voteOptions[safe: index] {
          print("index, direction: \(index), \(direction)")
          state.voteOptions.remove(at: index)
          state.isVoteButtonDisabled = state.voteOptions.isEmpty
          
          if direction == .right {
            state.pickedImageIDs.append(voteOption.optionID)
          }
          
          if state.voteOptions.isEmpty {
            return .send(.voteEnded)
          } else {
            return .none
          }
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
        return .send(.dismissVoteView)
        
      case let .getVoteOptions(.success(voteOptions)):
        state.voteOptions = voteOptions
        return .none
        
      case .getVoteOptions(.failure):
        return .none
        
      case let .postVoteResult(.success(voteResult)):
        return .none
        
      case let .postVoteResult(.failure):
        return .none

      case .resetButtonState:
        state.passButtonState = .defaultState
        state.voteButtonState = .defaultState
        return .none
        
      case .voteEnded:
        print("state.pickedImageIDs: \(state.pickedImageIDs)")
        return .run(
          operation: { [state] send in
            await send(.postVoteResult(Result {
              try await self.voteAPIClient.postVoteResult(
                state.userInfo.accessToken,
                state.eventID,
                state.pickedImageIDs
              )
            }))
          }, catch: { error, send in
          
          }
        )
        
      case let .swipeCard(direction):
        state.swipeDirection = direction
        state.passButtonState = direction == .left ? .activate : .deactivate
        state.voteButtonState = direction == .left ? .deactivate : .activate
        return .none
        
      case .dismissVoteView:
        return .none
      }
    }
  }
}
