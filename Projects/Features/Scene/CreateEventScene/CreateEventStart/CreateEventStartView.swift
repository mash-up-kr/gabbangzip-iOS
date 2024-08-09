//
//  CreateEventStartView.swift
//  CreateEvent
//
//  Created by Hyun A Song on 8/8/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import ComposableArchitecture
import DesignSystem
import SwiftUI

public struct CreateEventStartView: View {
  private let store: StoreOf<CreateEventStartCore>

  public init(store: StoreOf<CreateEventStartCore>) {
    self.store = store
  }

  public var body: some View {
    GeometryReader { geometry in
      VStack(spacing: 0) {
        NavigationBar(
          type: .titleWithBackButtonAndIcon(store.groupName, DesignSystem.Icons.group),
          backButtonAction: { store.send(.moveToGroupDetail) },
          rightIconAction: { store.send(.moveToGroupMemberList) }
        )
        
        Text(CreateEventStartViewNameSpace.eventTitle)
          .font(.head20)
          .multilineTextAlignment(.center)
          .foregroundStyle(DesignSystem.Colors.gray80)
          .padding(.top, 64)
        
        Text(CreateEventStartViewNameSpace.eventSubtitle)
          .font(.body14)
          .foregroundStyle(DesignSystem.Colors.gray60)
          .padding(.top, 15)
        
        LottieView(
          type: .morphing,
          loopMode: .loop
        )
        .frame(width: geometry.size.width - 229, height: geometry.size.width - 229)
        .padding(.top, 99)
        
        Spacer()
        GabbangzipBottomButton(
          type: .active,
          title: CreateEventStartViewNameSpace.buttonTitle,
          action: { store.send(.createEventButtonTapped) }
        )
        .padding(.bottom, 9)
      }
    }
    .onAppear {
      store.send(.onAppear)
    }
  }
}

// MARK: - CreateEventStartViewNameSpace
extension CreateEventStartView {
  fileprivate enum CreateEventStartViewNameSpace {
    static let eventTitle = "이벤트를 생성하고\n함께한 순간을 공유해요!"
    static let eventSubtitle = "공유한 사진을 함께 PIC하면 네컷사진을 만들 수 있어요."
    static let buttonTitle = "이벤트 만들기"
  }
}

#Preview {
  CreateEventStartView(
    store: Store(
      initialState: CreateEventStartCore.State(
        groupName: "가빵집"
      ),
      reducer: CreateEventStartCore.init
    )
  )
}
