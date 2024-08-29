//
//  EventDefaultView.swift
//  GroupDetail
//
//  Created by hyerin on 8/29/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import Common
import ComposableArchitecture
import DesignSystem
import Lovebug
import Models
import SwiftUI

public struct EventDefaultView: View {
  @Bindable var store: StoreOf<GroupDetailCore>
  
  public init(store: StoreOf<GroupDetailCore>) {
    self.store = store
  }
  
  public var body: some View {
    VStack(spacing: 0) {
      completedImage
      .padding(.horizontal, 41.5)
      .padding(.vertical, 16)

      SmallButton(
        type: .active,
        smallButtonContentType: .generateEvent
      ) {
        store.send(.createEventButtonTapped)
      }
      .padding(.bottom, 32)
    }
  }
  
  @ViewBuilder
  private var completedImage: some View {
    if let groupDetail = store.groupDetail {
      PhotoCard(status: groupDetail.keyword.convertToPhotoCardStatus()) {
        PhotoCardBackView(
          recentEventDate: store.recentEventDateString,
          cardBackImages: groupDetail.cardBackImages ?? [],
          recentEventName: groupDetail.recentEventDetail.name,
          foregroundColor: groupDetail.keyword.foregroundColor,
          s3BucketDomain: store.s3BucketDomain
        )
      }
    } else {
      EmptyView()
    }
  }
}

#Preview {
  EventCompletedView(
    store: .init(
      initialState: .init(
        groupID: 0,
        groupDetail: .mock,
        selectedPhotosInfo: Array<PhotoInfo>(),
        toastType: .onlyText(""),
        s3BucketDomain: "",
        showActivityView: false,
        capturedImage: nil
      ),
      reducer: {
        GroupDetailCore.init()
      })
    )
}
