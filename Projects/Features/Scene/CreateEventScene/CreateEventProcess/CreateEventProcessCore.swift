//
//  CreateEventProcessCore.swift
//  CreateEvent
//
//  Created by Hyun A Song on 8/8/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import Common
import ComposableArchitecture
import DesignSystem
import Models
import Services

@Reducer
public struct CreateEventProcessCore {
  public init() {}
  
  @ObservableState
  public struct State: Equatable {
    public var text: String
    public var isExiting: Bool
    public var completeButtonType: ButtonType
    
    public init(
      text: String = "",
      isExiting: Bool = false,
      completeButtonType: ButtonType = .inactive
    ) {
      self.text = text
      self.isExiting = isExiting
      self.completeButtonType = completeButtonType
    }
  }
  
  public enum Action: BindableAction {
    case binding(BindingAction<State>)
    
    // View Action
    case textChanged(String)
    case backButtonTapped
    case popupLeftButtonTapped
    case popupRightButtonTapped
    case completeButtonTapped
    case onAppear
    
    // Internal Action
    case setCompleteButtonType(ButtonType)
    
    // Route Action
  }
  
  @Dependency(\.bundleClient) var bundleClient
  @Dependency(\.uiPasteBoardClient) var uiPasteBoardClient
  
  public var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .binding:
        return .none
        
      case let .textChanged(text):
        state.text = text
        
        return .run { [state] send in
          if state.text.isEmpty {
            await send(.setCompleteButtonType(.inactive))
          } else {
            await send(.setCompleteButtonType(.active))
          }
        }
        
      case .backButtonTapped:
        return .none
        
      case .popupLeftButtonTapped:
        return .none
        
      case .popupRightButtonTapped:
        return .none
        
      case .completeButtonTapped:
        return .none
        
      case .onAppear:
        return .none
        
      case let .setCompleteButtonType(buttonType):
        state.completeButtonType = buttonType
        return .none
      }
    }
  }
}
