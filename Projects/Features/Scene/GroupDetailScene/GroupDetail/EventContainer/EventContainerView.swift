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
  private let groupDetail: GroupDetailInfo
  private var action: (GroupData.Status) -> Void
  @Bindable var store: StoreOf<GroupDetailCore>
  
  init(
    groupDetail: GroupDetailInfo,
    action: @escaping (GroupData.Status) -> Void,
    store: StoreOf<GroupDetailCore>
  ) {
    self.groupDetail = groupDetail
    self.action = action
    self.store = store
  }
  
  var body: some View {
    switch groupDetail.status {
    case .noCurrentEvent:
      // TODO: 디자인 작업 완료 후 작업해야함
      Rectangle()
        .fill(.red)
    case .beforeMyUpload, .afterMyUpload, .beforeMyVote, .afterMyVote: 
      EventProgressView(
        groupDetail: groupDetail,
        action: {
          action(groupDetail.status)
        }
      )
    case .eventCompleted:
      EventCompletedView(store: store.scope(
        state: \.eventCompletedState,
        action: \.eventCompleted
      ))
    case .noPastAndCurrentEvent:
      // 해당 화면에 접근 불가능한 조건
      EmptyView()
    }
  }
}
