//
//  GroupGridCore.swift
//  Main
//
//  Created by YangJoonHyeok on 9/25/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import ComposableArchitecture

@Reducer
public struct GroupGridCore {
  public init() {}

  @ObservableState
  public struct State: Equatable {
    var groupGridItems: IdentifiedArrayOf<GroupGridItemCore.State>
    
    public init(
      groupGridItems: IdentifiedArrayOf<GroupGridItemCore.State> = []
    ) {
      self.groupGridItems = groupGridItems
    }
  }

  public enum Action {
    // Child Action
    case groupGridItems(IdentifiedActionOf<GroupGridItemCore>)
  }

  public var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .groupGridItems:
        return .none
      }
    }
  }
}
