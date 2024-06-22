//
//  MemberListCore.swift
//  GroupDetail
//
//  Created by 최혜린 on 6/22/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import ComposableArchitecture

@Reducer
public struct MemberListCore {
  public struct State: Equatable {

    public init() {
    }
  }

  public enum Action {
  }

  public var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      }
    }
  }
}
