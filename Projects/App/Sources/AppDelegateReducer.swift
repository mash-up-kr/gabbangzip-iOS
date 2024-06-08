//
//  AppDelegateReducer.swift
//  App
//
//  Created by YangJoonHyeok on 6/8/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import ComposableArchitecture

@Reducer
struct AppDelegateReducer {
  @ObservableState
  struct State: Equatable {
  }

  enum Action {
    case didFinishLaunching
  }

  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .didFinishLaunching:
        // TODO: 써드파티 SDK 초기화 및 설정
        return .none
      }
    }
  }
}
