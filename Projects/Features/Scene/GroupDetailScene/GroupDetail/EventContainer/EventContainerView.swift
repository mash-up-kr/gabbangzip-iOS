//
//  EventContainerView.swift
//  GroupDetail
//
//  Created by 최혜린 on 6/29/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import DesignSystem
import Models
import NukeUI
import SwiftUI

struct EventContainerView: View {
  private let groupDetail: GroupDetailInfo
  private var action: (GroupData.Status) -> Void
  
  init(
    groupDetail: GroupDetailInfo,
    action: @escaping (GroupData.Status) -> Void
  ) {
    self.groupDetail = groupDetail
    self.action = action
  }
  
  var body: some View {
    switch groupDetail.status {
    case .noCurrentEvent, .noPastAndCurrentEvent:
      // TODO: 그룹 목록 썸네일 뷰로 대체 필요
      Rectangle()
        .fill(.red)
    case .beforeMyUpload, .afterMyUpload, .beforeMyVote, .afterMyVote: 
      EventProgressView(
        groupDetail: groupDetail,
        action: {
          action(groupDetail.status)
        }
      )
//      EventProgressView(
//        eventDetail: eventDetail,
//        action: {
//          action(eventDetail.state)
//        }
//      )
    case .eventCompleted:
      // TODO: 그룹 목록 썸네일 뷰 + complete view 생성 필요
      Rectangle()
        .fill(.red)
    }
  }
}

// 진행 중인 이벤트 없는 경우
#Preview {
  EventContainerView(
    groupDetail: .mock,
    action: {_ in }
  )
}

//// 사진 등록 진행 중, 내 pic 등록 전
//#Preview {
//  EventContainerView(eventDetail: .mock(state: .beforeMyUpload)) { _ in }
//}
//
//// 사진 등록 진행 중, 내 pic 등록 후
//#Preview {
//  EventContainerView(eventDetail: .mock(state: .afterMyUpload)) { _ in }
//}
//
//// 투표 진행 중, 투표 완료 전
//#Preview {
//  EventContainerView(eventDetail: .mock(state: .beforeMyVote)) { _ in }
//}
//
//// 투표 진행 중, 투표 완료 후
//#Preview {
//  EventContainerView(eventDetail: .mock(state: .afterMyVote)) { _ in }
//}
