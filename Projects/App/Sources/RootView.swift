//
//  RootView.swift
//  App
//
//  Created by gabbangzip on 5/20/24.
//

import ComposableArchitecture
import DesignSystem
import SwiftUI

public struct RootView: View {
  public let store: StoreOf<RootCore>
  
  public init(store: StoreOf<RootCore>) {
    self.store = store
  }
  
  public var body: some View {
    ZStack {
      VStack {
        Image(uiImage: DesignSystem.Icons.Login.logoUIImage)
          .resizable()
          .scaledToFit()
          .frame(width: 100)
        Spacer()
          .frame(height: 8)
        Text("우리가 픽! 하는\n우리끼리 네컷앨범")
          .font(DesignSystemFontFamily.Pretendard.regular.font(size: 10))
          .multilineTextAlignment(.center)
          .foregroundStyle(DesignSystem.Colors.gray80)
          .padding()
        Spacer()
          .frame(height: 400)
        Button(action: {}, label: {
          Image(uiImage: DesignSystem.Icons.Login.kakaoUIImage)
            .resizable()
            .scaledToFit()
            .frame(width: 350)
        })
      }
      LottieView(type: .login)
        .frame(width: 600)
    }
    .onOpenURL { url in
      store.send(.onOpenURL(url))
    }
  }
}

#Preview {
  RootView(
    store: Store(
      initialState: RootCore.State(),
      reducer: { RootCore() }
    )
  )
}
