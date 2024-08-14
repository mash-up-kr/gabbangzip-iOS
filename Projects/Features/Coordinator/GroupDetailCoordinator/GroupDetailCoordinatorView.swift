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
        case let .historyDetail(store):
          HistoryDetailView(store: store)
        case let .memberList(store):
          MemberListView(store: store)
        case let .vote(store):
          VoteView(store: store)
        case let .voteComplete(store):
          VoteCompleteView(store: store)
        }
      }
      .toolbar(.hidden)
    }
  }
}

