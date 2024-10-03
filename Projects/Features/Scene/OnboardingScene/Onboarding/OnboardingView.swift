//
//  OnboardingView.swift
//  Scene
//
//  Created by Hyun A Song on 10/3/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import ComposableArchitecture
import DesignSystem
import SwiftUI

public struct OnboardingView: View {
  @Bindable public var store: StoreOf<OnboardingCore>
  
  public init(store: StoreOf<OnboardingCore>) {
    self.store = store
  }
  
  public var body: some View {
    ZStack {
      OnboardingImageView(store: store)
      
      VStack {
        Spacer()
        
        PageNationView(currentIndex: $store.currentIndex)
        
        GabbangzipBottomButton(
          type: .active,
          title: "시작하기",
          action: {
            store.send(.startButtonTapped)
          }
        )
        .padding(.vertical, 16)
        .padding(.horizontal, 16)
      }
    }
  }
}

// MARK: - 온보딩 페이지 네이션 뷰
fileprivate struct PageNationView: View {
  @Binding var currentIndex: Int
  
  var body: some View {
    HStack {
      ForEach(0...3, id: \.self) { index in
        Circle()
          .fill(index == currentIndex ? DesignSystem.Colors.gray80 : DesignSystem.Colors.gray40)
          .frame(width: 8, height: 8)
          .padding(5)
      }
    }
    .padding(.vertical, 16)
  }
}

// MARK: - 온보딩 이미지 뷰
fileprivate struct OnboardingImageView: View {
  @Bindable public var store: StoreOf<OnboardingCore>
  private let images = [
    DesignSystem.Images.onboarding01,
    DesignSystem.Images.onboarding02,
    DesignSystem.Images.onboarding03,
    DesignSystem.Images.onboarding04
  ]
  
  var body: some View {
    TabView(
      selection:
        Binding(
          get: { store.currentIndex },
          set: { newIndex, transaction in
            store.send(.changeCurrentIndex(newIndex - store.currentIndex))
          }
        )
    ) {
      ForEach(0..<images.count, id: \.self) { index in
        images[index]
          .resizable()
          .scaledToFit()
          .ignoresSafeArea()
          .tag(index)
      }
    }
    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
  }
}

#Preview {
  OnboardingView(
    store: Store(
      initialState: .init(),
      reducer: OnboardingCore.init
    )
  )
}
