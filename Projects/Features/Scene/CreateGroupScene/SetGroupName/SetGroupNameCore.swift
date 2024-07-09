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
    
    
    public init(
      text: String = "",
      nextButtonType: ButtonType = .inactive
    ) {
      self.text = text
      self.nextButtonType = nextButtonType
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
    case moveToSelectKeyword
    case backToCreateGroupStart
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
        return .send(.moveToSelectKeyword)
        
      case .backButtonTapped:
        return .send(.backToCreateGroupStart)
        
      case let .setNextButtonType(value):
        state.nextButtonType = value
        return .none
        
      case .moveToSelectKeyword:
        return .none
        
      case .backToCreateGroupStart:
        return .none
      }
    }
  }
}
