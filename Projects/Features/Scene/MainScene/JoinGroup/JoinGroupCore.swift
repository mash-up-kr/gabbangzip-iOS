//
//  JoinGroupCore.swift
//  Main
//
//  Created by YangJoonHyeok on 7/29/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import ComposableArchitecture
import DesignSystem
import Models

@Reducer
public struct JoinGroupCore {
	public init() {}
	
	@ObservableState
  public struct State: Equatable {
    @Shared var userInfo: UserInfo
    var text: String
    var toastPresented: Bool
    var nextButtonType: ButtonType {
      text.isEmpty ? .inactive : .active
    }

    public init(
      userInfo: @autoclosure () -> UserInfo = .defaultValue,
      text: String = "",
      toastPresented: Bool = false
    ) {
      self._userInfo = Shared(wrappedValue: userInfo(), .inMemory("userInfo"))
      self.text = text
      self.toastPresented = toastPresented
    }
  }

  public enum Action {
    
    // View Action
    case backButtonTapped
    case textChanged(String)
    case nextButtonTapped
    case toastPresentedChanged(Bool)
    
    // Internal Action
    
    // Route Action
    case backToGroupList
  }

  public var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .backButtonTapped:
        return .none
        
      case let .textChanged(text):
        state.text = text
        return .none
        
      case .nextButtonTapped:
        return .none
        
      case let .toastPresentedChanged(value):
        state.toastPresented = value
        return .none
        
      case .backToGroupList:
        return .none
      }
    }
  }
}
