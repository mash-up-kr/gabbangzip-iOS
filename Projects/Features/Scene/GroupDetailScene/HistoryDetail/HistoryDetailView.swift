//
//  HistoryDetailView.swift
//  GroupDetail
//
//  Created by 최혜린 on 7/6/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import ComposableArchitecture
import DesignSystem
import Lovebug
import Models
import SwiftUI

public struct HistoryDetailView: View {
  private let store: StoreOf<HistoryDetailCore>
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
        
        if let keyword = store.keyword {
          PhotoCard(
            status: keyword.convertToPhotoCardStatus()
          ) {
            PhotoCardBackView(
              recentEventDate: store.eventDate,
              cardBackImages: store.history.images,
              recentEventName: store.history.name,
              foregroundColor: keyword.foregroundColor,
              s3BucketDomain: store.s3BucketDomain
            )
          }

          Spacer()
        }
      }
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
