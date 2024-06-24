//
//  RootCore.swift
//  App
//
//  Created by Hyun A Song on 6/19/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import ComposableArchitecture
import Foundation

@Reducer
public struct RootCore {
  @ObservableState
  public struct State: Equatable {
    
    init() {}
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
