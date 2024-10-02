//
//  HistoryDetailView.swift
//  GroupDetail
//
//  Created by 최혜린 on 7/6/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import Common
import ComposableArchitecture
import DesignSystem
import Lovebug
import Models
import SwiftUI

public struct HistoryDetailView: View {
  @Bindable private var store: StoreOf<HistoryDetailCore>
  @Environment(\.displayScale) private var scale
  private let background = DesignSystem.Colors.gray100

  public init(store: StoreOf<HistoryDetailCore>) {
    self.store = store
  }

  public var body: some View {
    ZStack {
      background
        .ignoresSafeArea()
      
      VStack {
        NavigationBar(
          type: .titleWithBackButton(store.history.name, .left),
          isDarkMode: true,
          backButtonAction: {
            store.send(.backButtonTapped)
          }
        )
        .padding(.bottom, 50)
        
        completedImage
          .padding(.bottom, 32)
        
        ShareButton {
          DispatchQueue.main.async {
            captureView(
              of: captureView,
              scale: scale,
              size: CGSize(width: 310, height: 420)
            ) { capturedImage in
              store.send(.shareButtonTapped)
              store.send(.imageCaptured(capturedImage))
            }
          }
        }
        
        Spacer()
      }
    }
    .background(
      ActivityView(
        isPresented: $store.showActivityView,
        activityItems: [store.capturedImage]
      ) {
        store.send(.completeActivity)
      }
    )
  }
  
  @ViewBuilder
  private var completedImage: some View {
    if let keyword = store.keyword {
      PhotoCard(
        status: keyword.convertToPhotoCardStatus()
      ) {
        PhotoCardBackView(
          recentEventDate: store.eventDate,
          cardBackImages: store.history.images,
          recentEventName: store.history.name,
          foregroundColor: keyword.foregroundColor,
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
    if let keyword = store.keyword {
      PhotoCard(
        status: keyword.convertToPhotoCardStatus(),
        content: {
          PhotoCardBackViewForCapture(
            recentEventDate: store.eventDate,
            cardBackImages: store.loadedImageModels,
            recentEventName: store.history.name,
            foregroundColor: keyword.foregroundColor
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
  HistoryDetailView(
    store: .init(
      initialState: .init(
        history: .mock,
        keyword: .company,
        s3BucketDomain: ""
      ),
      reducer: {
        HistoryDetailCore()
      }
    )
  )
}
