//
//  CreateGroupCoordinatorView.swift
//  CreateGroupCoordinator
//
//  Created by YangJoonHyeok on 7/21/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import ComposableArchitecture
import CreateGroup
import SwiftUI
import TCACoordinators

public struct CreateGroupCoordinatorView: View {
  let store: StoreOf<CreateGroupCoordinatorCore>
  
  public init(store: StoreOf<CreateGroupCoordinatorCore>) {
    self.store = store
  }
  
  public var body: some View {
    TCARouter(store.scope(state: \.routes, action: \.router)) { screen in
      Group {
        switch screen.case {
        case let .createGroupStart(store):
          CreateGroupStartView(store: store)
        case let .setGroupName(store):
          SetGroupNameView(store: store)
        case let .selectKeyword(store):
          SelectKeywordView(store: store)
        case let .selectGroupPhoto(store):
          SelectGroupPhotoView(store: store)
        case let .createGroupCompletion(store):
          CreateGroupCompletionView(store: store)
        }
      }
      .navigationBarHidden(true)
    }
  }
}
