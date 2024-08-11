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
import SwiftUI

public struct EventCompletedView: View {
  @Bindable var store: StoreOf<EventCompletedCore>
  
  public init(store: StoreOf<EventCompletedCore>) {
    self.store = store
  }
  
  public var body: some View {
    VStack(spacing: 0) {
      Text("네컷 사진이 만들어졌어요!")
        .foregroundStyle(DesignSystem.Colors.gray80)
        .font(.head20)
        .padding(.vertical, 16)
      
      completedImage
      .padding(.horizontal, 41.5)
      .padding(.bottom, 16)
      
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
    // TODO: loveBug 머지 후 수정 필요
    PhotoCard(status: .crew) {
      DesignSystem.Icons.hamburgerFrame
        .resizable()
        .aspectRatio(contentMode: .fit)
        .foregroundStyle(DesignSystem.Colors.mayaBlue30)
        .background(DesignSystem.Colors.gray0)
        .padding(.horizontal, 30)
        .padding(.vertical, 44)
    }
  }
}

#Preview {
  EventCompletedView(
    store: Store(
      initialState: .init(
        capturedImage: DesignSystem.Images.emptyUIImage
      ),
      reducer: EventCompletedCore.init
    )
  )
}
