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

struct OnboardingView: View {
  @Bindable public var store: StoreOf<MyPageCore>
  
  public var body: some View {
    ZStack {
      OnboardingImageView(currentIndex: $store.currentIndex)
      
      VStack {
        Spacer()
        
        PageNationView(currentIndex: $store.currentIndex)
        
        GabbangzipBottomButton(
          type: .active,
          title: "시작하기",
          action: {
            
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
  @Binding var currentIndex: Int
  @State private var dragOffset: CGSize = .zero
  private let images = [
    DesignSystem.Images.onboarding01,
    DesignSystem.Images.onboarding02,
    DesignSystem.Images.onboarding03,
    DesignSystem.Images.onboarding04
  ]
  
  var body: some View {
    GeometryReader { geo in
      images[currentIndex]
        .resizable()
        .scaledToFit()
        .frame(width: geo.size.width, height: geo.size.height)
        .contentShape(Rectangle())
        .gesture(
          DragGesture()
            .onChanged { value in
              dragOffset = value.translation
            }
            .onEnded { value in
              if value.translation.width < -100 && currentIndex < images.count - 1 {
                currentIndex += 1
              } else if value.translation.width > 100 && currentIndex > 0 {
                currentIndex -= 1
              }
              dragOffset = .zero
            }
        )
        .onTapGesture { location in
          let halfWidth = geo.size.width / 2
          if location.x < halfWidth && currentIndex > 0 {
            currentIndex -= 1
          } else if location.x >= halfWidth && currentIndex < images.count - 1 {
            currentIndex += 1
          }
        }
    }
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
