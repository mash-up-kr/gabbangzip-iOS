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
    var isToastPresented: Bool
    var popupType: VotePopupType
    var toastType: VoteToastType
    var isFirstVoteDone: Bool
    var isNeedGuideView: Bool
    var isVoteButtonDisabled: Bool
    var guideTypes: [GuideType]
    
    public init(
      userInfo: @autoclosure () -> UserInfo = .defaultValue,
      voteButtonState: VoteButtonState = .defaultState,
      passsButtonState: VoteButtonState = .defaultState,
      eventID: Int,
      voteOptions: [VoteOptionInfo] = [],
      pickedImageIDs: [Int] = [],
      swipeDirection: SwipeDirection = .defaultState,
      isPopupPresented: Bool = false,
      isToastPresented: Bool = false,
      popupType: VotePopupType = .close,
      toastType: VoteToastType = .error,
      isFirstVoteDone: Bool = false,
      isNeedGuideView: Bool = false,
      isVoteButtonDisabled: Bool = false,
      guideTypes: [GuideType] = [.pass, .vote]
    ) {
      self._userInfo = Shared(wrappedValue: userInfo(), .inMemory("userInfo"))
      self.voteButtonState = voteButtonState
      self.passButtonState = passsButtonState
      self.eventID = eventID
      self.voteOptions = voteOptions
      self.pickedImageIDs = pickedImageIDs
      self.swipeDirection = swipeDirection
      self.isPopupPresented = isPopupPresented
      self.isToastPresented = isToastPresented
      self.popupType = popupType
      self.toastType = toastType
      self.isFirstVoteDone = isFirstVoteDone
      self.isNeedGuideView = isNeedGuideView
      self.isVoteButtonDisabled = isVoteButtonDisabled
      self.guideTypes = guideTypes
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
    case guideViewSwiped
    
    // Internal Action
    case getVoteOptions(Result<[VoteOptionInfo], Error>)
    case postVoteResult(Result<VoteCompleteInfo, Error>)
    case showToast(VoteToastType)
    case resetButtonState
    case voteEnded
    case swipeCard(SwipeDirection)
    case setToastPresented(Bool)
    case setVoteOptions([VoteOptionInfo])
    case checkFirstVote
    case updateIsFirstVoteDone(Bool)
    case updateIsNeedGuideView(Bool)
    
    // Route Action
    case dismissVoteView
    case moveToVoteComplete(VoteCompleteInfo)
  }
  
  @Dependency(\.mainQueue) var mainQueue
  @Dependency(\.voteAPIClient) var voteAPIClient
  @Dependency(\.bundleClient) var bundleClient
  @Dependency(\.userDefaultsClient) var userDefaultClient

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
            
            await send(.checkFirstVote)
          }, catch: { error, send in
          
          }
        )
        
      case .passButtonTapped:
        return .run { send in
          await send(.swipeCard(.left))
          try await mainQueue.sleep(for: .seconds(1.0))
          await send(.resetButtonState)
        }
        
      case .voteButtonTapped:
        return .run { send in
          await send(.swipeCard(.right))
          try await mainQueue.sleep(for: .seconds(1.0))
          await send(.resetButtonState)
        }
        
      case let .cardSwiped(index, direction):
        state.swipeDirection = .defaultState
        if let voteOption = state.voteOptions[safe: index] {
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
          return .send(.showToast(.error))
        }

      case .exitButtonTapped:
        state.isPopupPresented = true
        state.popupType = .close
        return .none
        
      case .popupLeftButtonTapped:
        state.isPopupPresented = false
        return .none
        
      case .popupRightButtonTapped:
        state.isPopupPresented = false
        return .send(.dismissVoteView)
        
      case .guideViewSwiped:
        if !state.guideTypes.isEmpty {
          state.guideTypes.removeFirst()
        }
        return .none
        
      case let .getVoteOptions(.success(voteOptions)):
        return .run { send in
          let voteOptionsWithDomain = voteOptions.map {
            if let s3BucketDomain = try? bundleClient.getValue("S3BucketDomain") as? String {
              let imageURLString = s3BucketDomain + $0.imageURL
              return VoteOptionInfo(optionID: $0.optionID, imageURL: imageURLString)
            } else {
              return VoteOptionInfo.emptyItem
            }
          }
          
          await send(.setVoteOptions(voteOptionsWithDomain))
        }

      case .getVoteOptions(.failure):
        return .send(.showToast(.error))
        
      case let .postVoteResult(.success(voteResult)):
        return .run { [state] send in
          if !state.isFirstVoteDone {
            userDefaultClient.set(.isFirstVoteDone, true)
          }
          
          await send(.moveToVoteComplete(voteResult))
        }
        
      case .postVoteResult(.failure):
        return .send(.showToast(.error))
        
      case let .showToast(toastType):
        state.isToastPresented = true
        state.toastType = toastType
        return .none

      case .resetButtonState:
        state.passButtonState = .defaultState
        state.voteButtonState = .defaultState
        return .none
        
      case .voteEnded:
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
        
      case let .setToastPresented(isToastPresented):
        state.isToastPresented = isToastPresented
        return .none
        
      case let .setVoteOptions(voteOptions):
        state.voteOptions = voteOptions
        return .none
        
      case .checkFirstVote:
        return .run(
          operation: { send in
            let isFirstVoteDone = try? userDefaultClient.bool(.isFirstVoteDone)
            
            if let isFirstVoteDone, !isFirstVoteDone {
              await send(.updateIsFirstVoteDone(isFirstVoteDone))
              await send(.updateIsNeedGuideView(isFirstVoteDone))
            }
          }, catch: { error, send in
          
          }
        )
        
      case let .updateIsFirstVoteDone(isFirstVoteDone):
        state.isFirstVoteDone = isFirstVoteDone
        return .none
        
      case let .updateIsNeedGuideView(isFirstVoteDone):
        state.isNeedGuideView = !isFirstVoteDone
        return .none
        
      case .dismissVoteView:
        return .none
        
      case .moveToVoteComplete:
        return .none
      }
    }
  }
}

extension VoteCore {
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
  
  public enum VoteToastType {
    case error
    
    var message: String {
      switch self {
      case .error:
        return "오류가 발생했습니다. 다시 시도해주세요."
      }
    }
  }
}
