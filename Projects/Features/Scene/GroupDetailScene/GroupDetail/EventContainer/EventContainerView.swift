//
//  EventContainerView.swift
//  GroupDetail
//
//  Created by 최혜린 on 6/29/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import ComposableArchitecture
import DesignSystem
import Models
import NukeUI
import SwiftUI

struct EventContainerView: View {
  private let groupDetail: GroupDetailInfo?
  private var action: (GroupData.Status) -> Void
  private var store: StoreOf<GroupDetailCore>
  
  init(
    groupDetail: GroupDetailInfo?,
    action: @escaping (GroupData.Status) -> Void,
    store: StoreOf<GroupDetailCore>
  ) {
    self.groupDetail = groupDetail
    self.action = action
    self.store = store
  }
  
  var body: some View {
    if let groupDetail {
      switch groupDetail.status {
      case .beforeMyUpload, .afterMyUpload, .beforeMyVote, .afterMyVote:
        EventProgressView(
          action: {
            action(groupDetail.status)
          },
          store: store
        )
      case .noCurrentEvent, .eventCompleted:
        EventCompletedView(store: store)
      case .noPastAndCurrentEvent:
        // 해당 화면에 접근 불가능한 조건
        EmptyView()
      }
    } else {
      EmptyView()
    }
  }
}
