//
//  VoteCore.swift
//  GroupDetail
//
//  Created by hyerin on 7/18/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import ComposableArchitecture

@Reducer
public struct VoteCore {
  
  public init() {}

  @ObservableState
  public struct State: Equatable {
    var name: String
    
    public init(
      name: String
    ) {
      self.name = name
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
