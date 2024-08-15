//
//  MainCoordinatorView.swift
//  MainCoordinator
//
//  Created by YangJoonHyeok on 7/21/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import ComposableArchitecture
import CreateEvent
import CreateGroupCoordinator
import GroupDetailCoordinator
import Main
import MyPage
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
      case let .createEvent(store):
        CreateEventView(store: store)
      case let .myPage(store):
        MyPageView(store: store)
      case let .home(store):
        HomeView(store: store)
      case let .joinGroup(store):
        JoinGroupView(store: store)
      case let .groupDetailCoordinator(store):
        GroupDetailCoordinatorView(store: store)
      case let .getStarted(store):
        GetStartedView(store: store)
      }
    }
  }
}
