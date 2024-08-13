//
//  EventCompletedView.swift
//  GroupDetail
//
//  Created by hyerin on 8/11/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import Common
import ComposableArchitecture
import DesignSystem
import Lovebug
import Models
import SwiftUI

public struct EventCompletedView: View {
  @Bindable var store: StoreOf<GroupDetailCore>
  
  public init(store: StoreOf<GroupDetailCore>) {
    self.store = store
  }
  
  public var body: some View {
    VStack(spacing: 0) {
      if store.isNeedEventCompletedTitle {
        Text("네컷 사진이 만들어졌어요!")
          .foregroundStyle(DesignSystem.Colors.gray80)
          .font(.head20)
      }
      
      completedImage
      .padding(.horizontal, 41.5)
      .padding(.vertical, 16)
      
      ShareButton(action: {
        // TODO
//        store.send(.shareButtonTapped)
        captureView(of: completedImage) { capturedImage in
          // TODO
//          store.send(.imageCaptured(capturedImage))
        }
      })
        .padding(.bottom, 32)
    }
    .background(
      ActivityView(
        isPresented: $store.showActivityView,
        activityItems: [store.capturedImage]
      )
    )
  }
  
  private var completedImage: some View {
    PhotoCard(status: store.groupDetail.keyword.convertToPhotoCardStatus()) {
      PhotoCardBackView(
        recentEventDate: store.groupDetail.recentEventDetail.date,
        cardBackImages: store.groupDetail.cardBackImages,
        recentEventName: store.groupDetail.recentEventDetail.name,
        foregroundColor: store.groupDetail.keyword.foregroundColor,
        s3BucketDomain: store.s3BucketDomain
      )
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
