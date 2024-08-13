//
//  GroupDetailCoordinatorView.swift
//  GroupDetailCoordinator
//
//  Created by hyerin on 8/12/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import ComposableArchitecture
import GroupDetail
import SwiftUI
import TCACoordinators

public struct GroupDetailCoordinatorView: View {
  let store: StoreOf<GroupDetailCoordinatorCore>
  
  public init(store: StoreOf<GroupDetailCoordinatorCore>) {
    self.store = store
  }
  
  public var body: some View {
    TCARouter(store.scope(state: \.routes, action: \.router)) { screen in
      Group {
        switch screen.case {
        case let .groupDetail(store):
          GroupDetailView(store: store)
        }
      }
      .toolbar(.hidden)
    }
  }
}

