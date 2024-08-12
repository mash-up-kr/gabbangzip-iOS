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
  @Bindable var store: StoreOf<EventCompletedCore>
  
  public init(store: StoreOf<EventCompletedCore>) {
    self.store = store
  }
  
  public var body: some View {
    VStack(spacing: 0) {
      if store.isNeedTitle {
        Text("네컷 사진이 만들어졌어요!")
          .foregroundStyle(DesignSystem.Colors.gray80)
          .font(.head20)
      }
      
      completedImage
      .padding(.horizontal, 41.5)
      .padding(.vertical, 16)
      
      ShareButton(action: {
        store.send(.shareButtonTapped)
        captureView(of: completedImage) { capturedImage in
          store.send(.imageCaptured(capturedImage))
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
  
  var completedImage: some View {
    PhotoCard(status: store.keyword.convertToPhotoCardStatus()) {
      PhotoCardBackView(
        recentEventDate: store.recentEvent.date ?? "",
        cardBackImages: store.cardBackImage,
        recentEventName: store.recentEvent.name ?? "",
        foregroundColor: store.keyword.foregroundColor,
        s3BucketDomain: store.s3BucketDomain
      )
    }
  }
}

#Preview {
  EventCompletedView(
    store: Store(
      initialState: .init(
        status: .noCurrentEvent,
        capturedImage: DesignSystem.Images.emptyUIImage,
        keyword: .company,
        recentEvent: RecentEvent(
          id: 0,
          name: "테스트",
          date: "2024.07.01"
        ),
        s3BucketDomain: "",
        cardBackImage: [
          CardBackImage(imageURL: "https://24ai.tech/ru/wp-content/uploads/sites/4/2023/10/01_product_1_sdelat-kvadratnym-scaled.jpg", frame: .clover),
          CardBackImage(imageURL: "https://24ai.tech/ru/wp-content/uploads/sites/4/2023/10/01_product_1_sdelat-kvadratnym-scaled.jpg", frame: .flower),
          CardBackImage(imageURL: "https://24ai.tech/ru/wp-content/uploads/sites/4/2023/10/01_product_1_sdelat-kvadratnym-scaled.jpg", frame: .ghost),
          CardBackImage(imageURL: "https://24ai.tech/ru/wp-content/uploads/sites/4/2023/10/01_product_1_sdelat-kvadratnym-scaled.jpg", frame: .hamburger)
        ]
      ),
      reducer: EventCompletedCore.init
    )
  )
}
