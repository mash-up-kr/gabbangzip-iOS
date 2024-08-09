//
//  CreateEventCoordinatorView.swift
//  CreateEventCoordinator
//
//  Created by Hyun A Song on 8/8/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import ComposableArchitecture
import CreateEvent
import GroupDetail
import Main
import SwiftUI
import TCACoordinators

public struct CreateEventCoordinatorView: View {
  let store: StoreOf<CreateEventCoordinatorCore>
  
  public init(store: StoreOf<CreateEventCoordinatorCore>) {
    self.store = store
  }
  
  public var body: some View {
    TCARouter(store.scope(state: \.routes, action: \.router)) { screen in
      Group {
        switch screen.case {
        case let .createEventStart(store):
          CreateEventStartView(store: store)
        case let .moveToGroupDetail(store):
          GroupListView(store: store)
        case let .moveToGroupMemberList(store):
          MemberListView(store: store)
        case let .moveToCreateEventProcess(store):
          CreateEventProcessView(store: store)
        }
      }
      .toolbar(.hidden)
    }
  }
}
