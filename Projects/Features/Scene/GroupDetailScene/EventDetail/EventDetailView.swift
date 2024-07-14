//
//  EventDetailView.swift
//  GroupDetail
//
//  Created by 최혜린 on 7/6/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import ComposableArchitecture
import DesignSystem
import Models
import SwiftUI

struct EventDetailView: View {
  private let store: StoreOf<EventDetailCore>
  private let background = DesignSystem.Colors.gray100

  init(store: StoreOf<EventDetailCore>) {
    self.store = store
  }

  var body: some View {
    ZStack {
      background
        .ignoresSafeArea()
      
      VStack {
        NavigationBar(
          type: .titleWithBackButton(store.eventDetail.name),
          isDarkMode: true,
          backButtonAction: {
            store.send(.backButtonTapped)
          }
        )
        .padding(.bottom, 50)
        
        // TODO: 이미지 생성 필요
        RoundedRectangle(cornerRadius: 5)
          .foregroundStyle(.red)
        
        Spacer()
      }
    }
  }
}

#Preview {
  EventDetailView(
    store: Store(initialState: .init(
      eventDetail: .mock(state: .eventCompleted))
    ) {
      EventDetailCore()
    }
  )
}
