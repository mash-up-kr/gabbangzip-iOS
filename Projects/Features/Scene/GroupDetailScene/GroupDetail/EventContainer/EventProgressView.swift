//
//  EventProgressView.swift
//  GroupDetail
//
//  Created by 최혜린 on 6/29/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import DesignSystem
import Models
import NukeUI
import SwiftUI

struct EventProgressView: View {
  private let groupDetail: GroupDetailInfo
  private var action: () -> Void
  
  init(
    groupDetail: GroupDetailInfo,
    action: @escaping () -> Void
  ) {
    self.groupDetail = groupDetail
    self.action = action
  }
  
  var body: some View {
    VStack(spacing: 0) {
      Text(groupDetail.recentEvent.date)
        .foregroundStyle(DesignSystem.Colors.gray80)
        .font(.body16)
        .padding(.bottom, 8)
      
      Text(groupDetail.name)
        .foregroundStyle(DesignSystem.Colors.gray80)
        .font(.head20)
        .padding(.bottom, 8)
      
      Text("\(groupDetail.recentEvent.deadline) PIC 종료")
        .font(.text14)
        .foregroundStyle(DesignSystem.Colors.gray80)
        .padding(.bottom, 16)

//      LazyImage(url: groupDetail.imageURL) { state in
//        if let image = state.image {
//          image.resizable()
//            .aspectRatio(contentMode: .fit)
//            .padding(.horizontal, 76)
//        }
//      }
      
      if let message = groupDetail.status.message(time: groupDetail.recentEvent.deadline) {
        Text(message)
          .font(.caption12)
          .foregroundStyle(DesignSystem.Colors.gray60)
          .padding(.init(top: 24, leading: 0, bottom: 8, trailing: 0))
      }
      
      EventControlButton(
        buttonType: convertToButtonType(from: groupDetail.status),
        action: action
      )
    }
    .padding(.init(top: 16, leading: 0, bottom: 24, trailing: 0))
  }
  
  private func convertToButtonType(
    from state: GroupData.Status
  ) -> SmallButtonContentType? {
    switch state {
    case .noCurrentEvent, .noPastAndCurrentEvent:
      return .generateEvent
    case .beforeMyUpload:
      return .uploadPIC
    case .beforeMyVote:
      return .vote
    case .afterMyUpload, .afterMyVote:
      return .stabbing
    case .eventCompleted:
      return nil
    }
  }
}

#Preview {
  EventProgressView(
    groupDetail: .mock,
    action: {
      print("tapped")
    }
  )
}
