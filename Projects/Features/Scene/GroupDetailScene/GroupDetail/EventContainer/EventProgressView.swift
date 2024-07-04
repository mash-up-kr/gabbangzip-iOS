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
  let eventDetail: EventDetail
  private var action: () -> Void
  
  init(
    eventDetail: EventDetail,
    action: @escaping () -> Void
  ) {
    self.eventDetail = eventDetail
    self.action = action
  }
  
  var body: some View {
    VStack(spacing: 0) {
      Text(eventDetail.date)
        .foregroundStyle(DesignSystem.Colors.gray80)
        .font(.body16)
        .padding(.bottom, 8)
      
      Text(eventDetail.name)
        .foregroundStyle(DesignSystem.Colors.gray80)
        .font(.head20)
        .padding(.bottom, 8)
      
      Text("\(eventDetail.dueDate) PIC 종료")
        .font(.text14)
        .foregroundStyle(DesignSystem.Colors.gray80)
        .padding(.bottom, 16)

      LazyImage(
        url: eventDetail.imageURL
      ) { state in
        if let image = state.image {
          image.resizable()
            .aspectRatio(contentMode: .fit)
            .padding(.horizontal, 72)
        }
      }
      
      if let message = eventDetail.state.message(time: eventDetail.dueTime) {
        Text(message)
          .font(.caption12)
          .foregroundStyle(DesignSystem.Colors.gray60)
          .padding(
            EdgeInsets(
              top: 24,
              leading: 0,
              bottom: 8,
              trailing: 0
            )
          )
      }
      button
    }
    .padding(
      EdgeInsets(
        top: 16,
        leading: 0,
        bottom: 24,
        trailing: 0
      )
    )
  }
  
  @ViewBuilder
  var button: some View {
    if let smallButtonContentType = convertToButtonType(
      from: eventDetail.state
    ) {
      SmallButton(
        type: .constant(.active),
        smallButtonContentType: smallButtonContentType) {
          action()
        }
    } else {
      ShareButton {
        action()
      }
    }
  }
  
  private func convertToButtonType(
    from state: EventState
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
    eventDetail: EventDetail.mock(state: .afterMyUpload),
    action: {
      print("tapped")
    }
  )
}
