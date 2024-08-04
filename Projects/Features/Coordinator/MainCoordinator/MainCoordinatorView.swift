//
//  MainCoordinatorView.swift
//  MainCoordinator
//
//  Created by YangJoonHyeok on 7/21/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import ComposableArchitecture
import CreateGroupCoordinator
import Main
import MyPageCoordinator
import SwiftUI
import TCACoordinators

public struct MainCoordinatorView: View {
  let store: StoreOf<MainCoordinatorCore>
  
  public init(store: StoreOf<MainCoordinatorCore>) {
    self.store = store
  }
  
  public var body: some View {
    TCARouter(store.scope(state: \.routes, action: \.router)) { screen in
      switch screen.case {
      case let .createGroupCoordinator(store):
        CreateGroupCoordinatorView(store: store)
      case let .myPageCoordinator(store):
        MyPageCoordinatorView(store: store)
      case let .groupList(store):
        GroupListView(store: store)
      case let .joinGroup(store):
        JoinGroupView(store: store)
      }
    }
  }
}
