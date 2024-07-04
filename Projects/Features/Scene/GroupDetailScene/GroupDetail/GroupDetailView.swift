//
//  GroupDetailView.swift
//  GroupDetail
//
//  Created by 최혜린 on 6/29/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import Common
import ComposableArchitecture
import DesignSystem
import Models
import SwiftUI

public struct GroupDetailView: View {
  @State private var showSheet = true
  @State private var bottomSheetHeight: CGFloat = 0
  private let store: StoreOf<GroupDetailCore>

  public init(store: StoreOf<GroupDetailCore>) {
    self.store = store
  }

  public var body: some View {
    ScrollView {
      VStack(spacing: 0) {
        NavigationBar(
          type: .titleWithBackButtonAndIcon(store.groupDetail.groupName, DesignSystem.Icons.group),
          backButtonAction: {
            store.send(.backButtonTapped)
          },
          rightIconAction: {
            store.send(.memberListButtonTapped)
          }
        )
        
        EventContainerView(eventDetail: store.groupDetail.eventDetail) { state in
          store.send(.eventContainerViewButtonTapped(state))
        }
        
        dividerView
      }
      .overlay(ViewHeightGeometry())
      .onPreferenceChange(ViewHeightKey.self) { height in
        self.bottomSheetHeight = UIScreen.main.bounds.height - height - UIScreen.topSafeArea - UIScreen.bottomSafeArea
      }
    }
    .scrollIndicators(.hidden)
    .sheet(isPresented: $showSheet) {
      EventGridView(events: store.groupDetail.eventItems)
        .scrollIndicators(.hidden)
        .presentationDetents([.height(bottomSheetHeight), .large])
        .interactiveDismissDisabled()
        .presentationDragIndicator(.hidden)
        .presentationBackgroundInteraction(.enabled(upThrough: .large))
     }
  }
  
  private var dividerView: some View {
    Rectangle()
      .foregroundStyle(DesignSystem.Colors.gray20)
      .frame(height: 10)
  }
}

// 이벤트 목록 빈 경우
#Preview {
  GroupDetailView(
    store: Store(
      initialState: .init(groupDetail: GroupDetail.emptyMock),
      reducer: GroupDetailCore.init
    )
  )
}

// 이벤트 목록 있는 경우
#Preview {
  GroupDetailView(
    store: Store(
      initialState: .init(groupDetail: GroupDetail.mock),
      reducer: GroupDetailCore.init
    )
  )
}
