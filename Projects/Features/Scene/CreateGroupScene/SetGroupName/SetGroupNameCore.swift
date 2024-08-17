//
//  SetGroupNameCore.swift
//  CreateGroup
//
//  Created by YangJoonHyeok on 7/9/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import ComposableArchitecture
import DesignSystem

@Reducer
public struct SetGroupNameCore {
  public init() {}
  
  @ObservableState
  public struct State: Equatable {
    var text: String
    var nextButtonType: ButtonType
    var isFromGetStarted: Bool
    
    public init(
      text: String = "",
      nextButtonType: ButtonType = .inactive,
      isFromGetStarted: Bool
    ) {
      self.text = text
      self.nextButtonType = nextButtonType
      self.isFromGetStarted = isFromGetStarted
    }
  }
  
  public enum Action {
    // View Action
    case textChanged(String)
    case nextButtonTapped
    case backButtonTapped
    
    // Internal Action
    case setNextButtonType(ButtonType)
    
    // Route Action
    case moveToSelectKeyword(groupName: String, isFromGetStarted: Bool)
    case backToHome
    case backToGetStarted
  }
  
  public var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case let .textChanged(text):
        state.text = text
        
        return .run { [state] send in
          if state.text.isEmpty {
            await send(.setNextButtonType(.inactive))
          } else {
            await send(.setNextButtonType(.active))
          }
        }
        
      case .nextButtonTapped:
        return .send(.moveToSelectKeyword(groupName: state.text, isFromGetStarted: state.isFromGetStarted))
        
      case .backButtonTapped:
        if state.isFromGetStarted {
          return .send(.backToGetStarted)
        } else {
          return .send(.backToHome)
        }
        
      case let .setNextButtonType(value):
        state.nextButtonType = value
        return .none
        
      case .moveToSelectKeyword:
        return .none
        
      case .backToHome:
        return .none
        
      case .backToGetStarted:
        return .none
      }
    }
  }
}
