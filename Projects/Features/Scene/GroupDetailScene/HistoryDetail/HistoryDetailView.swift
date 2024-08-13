//
//  HistoryDetailView.swift
//  GroupDetail
//
//  Created by 최혜린 on 7/6/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import ComposableArchitecture
import DesignSystem
import Models
import SwiftUI

public struct HistoryDetailView: View {
  private let store: StoreOf<HistoryDetailCore>
  private let background = DesignSystem.Colors.gray100

  init(store: StoreOf<HistoryDetailCore>) {
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
        
        // TODO: 이미지 생성 필요
        RoundedRectangle(cornerRadius: 5)
          .foregroundStyle(.red)
        
        Spacer()
      }
    }
  }
}

#Preview {
  HistoryDetailView(
    store: Store(initialState: .init(
      history: .mock)
    ) {
      HistoryDetailCore()
    }
  )
}
