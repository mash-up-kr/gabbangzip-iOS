//
//  OnboardingCore.swift
//  Scene
//
//  Created by Hyun A Song on 10/3/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import ComposableArchitecture

@Reducer
public struct OnboardingCore {
  public init() {}
  
  @ObservableState
  public struct State: Equatable {
    public var currentIndex: Int
    
    public init(currentIndex: Int = 0) {
      self.currentIndex = currentIndex
    }
  }
  
  public enum Action: BindableAction {
    case binding(BindingAction<State>)
    
    // View Action
    case changeCurrentIndex(Int)
    case startButtonTapped
    
    // Route Action
    case moveToLogin
  }
  
  public var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .binding:
        return .none
        
      case let .changeCurrentIndex(value):
        state.currentIndex += value
        return .none
        
      case .startButtonTapped:
        return .run { send in
          await send(.moveToLogin)
        }
        
      case .moveToLogin:
        return .none
      }
    }
  }
}
