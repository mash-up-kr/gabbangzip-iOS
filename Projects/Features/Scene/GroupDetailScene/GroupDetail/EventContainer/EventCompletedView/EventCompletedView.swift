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
  @Environment(\.displayScale) private var scale
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
      
//      TODO: 공유하기 이미지 캡쳐 추후 확인 필요
      ShareButton(
        action: {
          DispatchQueue.main.async {
            captureView(
              of: captureView,
              scale: scale,
              size: CGSize(width: 310, height: 420)
            ) { capturedImage in
              store.send(.imageCaptured(capturedImage))
            }
          }
        }
      )
      .padding(.bottom, 32)
    }
    .overlay {
      if store.isNeedEventCompletedTitle {
        LottieView(
          type: .confetti,
          loopMode: .playOnce
        )
      }
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
          s3BucketDomain: store.s3BucketDomain,
          imageAllLoadedCompletion: { imageModels in
            store.send(.imageAllLoaded(imageModels))
          }
        )
      }
    } else {
      EmptyView()
    }
  }
  
  @ViewBuilder
  private var captureView: some View {
    if let groupDetail = store.groupDetail {
      PhotoCard(
        status: groupDetail.keyword.convertToPhotoCardStatus(),
        content: {
          PhotoCardBackViewForCapture(
            recentEventDate: store.recentEventDateString,
            cardBackImages: store.loadedImages,
            recentEventName: groupDetail.recentEventDetail.name,
            foregroundColor: groupDetail.keyword.foregroundColor
          )
        },
        isForCapture: true
      )
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
