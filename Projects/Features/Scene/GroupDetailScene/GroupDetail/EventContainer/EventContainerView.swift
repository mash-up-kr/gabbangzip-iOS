//
//  EventContainerView.swift
//  GroupDetail
//
//  Created by 최혜린 on 6/29/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

import DesignSystem
import Models

import Nuke
import NukeUI

public struct EventContainerView: View {
  let store: StoreOf<EventContainerCore>

  public init(store: StoreOf<EventContainerCore>) {
    self.store = store
  }

  public var body: some View {
    switch store.eventDetail.state {
    case .noEvent:
      // TODO: 그룹 목록 썸네일 뷰로 대체 필요
      Rectangle()
        .fill(.red)
    case .beforeRegisterMyPIC, .afterRegisterMyPIC, .beforeMyVote, .afterMyVote:
      EventProgressView(
        eventDetail: store.eventDetail,
        action: {
          store.send(.buttonDidTap(store.eventDetail.state))
        }
      )
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
    store: Store(
      initialState: .init(
        eventDetail: EventDetail.mock(state: .noEvent)
      )
    ) {
      EventContainerCore()
    }
  )
}

// 사진 등록 진행 중, 내 pic 등록 전
#Preview {
  EventContainerView(
    store: Store(
      initialState: .init(
        eventDetail: EventDetail.mock(state: .beforeRegisterMyPIC)
        )
    ) {
      EventContainerCore()
    }
  )
}


// 사진 등록 진행 중, 내 pic 등록 후
#Preview {
  EventContainerView(
    store: Store(
      initialState: .init(
        eventDetail: EventDetail.mock(state: .afterRegisterMyPIC)
        )
    ) {
      EventContainerCore()
    }
  )
}

// 투표 진행 중, 투표 완료 전
#Preview {
  EventContainerView(
    store: Store(
      initialState: .init(
        eventDetail: EventDetail.mock(state: .beforeMyVote)
        )
    ) {
      EventContainerCore()
    }
  )
}

// 투표 진행 중, 투표 완료 후
#Preview {
  EventContainerView(
    store: Store(
      initialState: .init(
        eventDetail: EventDetail.mock(state: .afterMyVote)
        )
    ) {
      EventContainerCore()
    }
  )
}
