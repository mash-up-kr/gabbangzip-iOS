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
          type: .titleWithBackButtonAndIcon(store.groupDetail?.name ?? "", DesignSystem.Icons.group),
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
    .background(DesignSystem.Colors.gray20)
    .background(
      ActivityView(
        isPresented: $store.showActivityView,
        activityItems: [store.capturedImage]
      )
    )
    .overlay {
      CustomBottomSheetView(
        minHeight: bottomSheetHeight + UIScreen.bottomSafeArea,
        maxHeight: UIScreen.main.bounds.height - UIScreen.topSafeArea,
        content: {
          HistoryGridView(
            histories: store.groupDetail?.history,
            keyword: store.groupDetail?.keyword,
            s3BucketDomain: store.s3BucketDomain,
            tapAction: { history in
              store.send(.historyViewTapped(history))
            }
          )
        }
      )
    }
    .photosPicker(
      isPresented: $store.photosPickerPresented.sending(\.photosPickerPresentedChanged),
      selection: $store.selectedPickerItems.sending(\.selectedPickerItemsChanged),
      maxSelectionCount: 4,
      matching: .images
    )
    .toast(
      isPresented: $store.isToastPresented,
      type: store.toastType,
      time: 1.0
    )
    .onAppear { store.send(.onAppear) }
  }
}

#Preview {
  GroupDetailView(
    store: Store(
      initialState: .init(
        groupID: 0,
        groupDetail: .mock,
        selectedPhotosInfo: [],
        toastType: .onlyText(""),
        s3BucketDomain: "",
        showActivityView: false,
        capturedImage: nil
      ),
      reducer: GroupDetailCore.init
    )
  )
}
