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
  @State private var bottomSheetHeight: CGFloat = 0
  @Bindable var store: StoreOf<GroupDetailCore>

  public init(store: StoreOf<GroupDetailCore>) {
    self.store = store
  }

  public var body: some View {
    ScrollView {
      VStack(spacing: 0) {
        NavigationBar(
          type: .titleWithBackButtonAndIcon(store.groupDetail.name, DesignSystem.Icons.group),
          backButtonAction: {
            store.send(.backButtonTapped)
          },
          rightIconAction: {
            store.send(.memberListButtonTapped)
          }
        )
        
        EventContainerView(
          groupDetail: store.groupDetail,
          action: { status in
            store.send(.eventContainerViewButtonTapped(status))
          },
          store: store
        )
      }
      .overlay(ViewHeightGeometry())
      .onPreferenceChange(ViewHeightKey.self) { height in
        self.bottomSheetHeight = UIScreen.main.bounds.height - height - UIScreen.topSafeArea - UIScreen.bottomSafeArea
      }
    }
    .scrollIndicators(.hidden)
    .sheet(isPresented: $store.showSheet) {
      HistoryGridView(histories: store.groupDetail.history)
        .presentationDetents([.height(bottomSheetHeight), .large])
        .interactiveDismissDisabled()
        .presentationDragIndicator(.hidden)
        .presentationBackgroundInteraction(.enabled(upThrough: .large))
     }
    .onAppear { store.send(.onAppear) }
    .background(DesignSystem.Colors.gray20)
  }
}

#Preview {
  GroupDetailView(
    store: Store(
      initialState: .init(
        groupID: 0,
        groupDetail: .noHistorymock
      ),
      reducer: GroupDetailCore.init
    )
  )
}
