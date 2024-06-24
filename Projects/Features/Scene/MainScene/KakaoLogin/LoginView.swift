//
//  LoginView.swift
//  Main
//
//  Created by Hyun A Song on 6/24/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import ComposableArchitecture
import DesignSystem
import SwiftUI

struct LoginView: View {
  public let store: StoreOf<LoginCore>
  
  public init(store: StoreOf<LoginCore>) {
    self.store = store
  }
  
  var body: some View {
    VStack {
      Spacer()
        .frame(height: 50)
      Image(uiImage: DesignSystem.Icons.Login.logoUIImage)
        .resizable()
        .scaledToFit()
        .frame(width: 100)
      Spacer()
        .frame(height: 8)
      Text("우리가 픽! 하는\n우리끼리 네컷앨범")
        .font(DesignSystemFontFamily.Pretendard.regular.font(size: 21))
        .multilineTextAlignment(.center)
        .foregroundStyle(DesignSystem.Colors.gray80)
        .padding()
      Spacer()
        .frame(height: 400)
      Button(action: {
        store.send(.loginButtonTapped)
      }, label: {
        Image(uiImage: DesignSystem.Icons.Login.kakaoUIImage
          .withPadding(.init(
            top: 0,
            left: 16,
            bottom: 0,
            right: 16)
          ))
        .resizable()
        .scaledToFit()
        .frame(width: UIScreen.main.bounds.size.width)
      })
    }
  }
}

#Preview {
  ZStack {
    LoginView(
      store: Store(
        initialState: LoginCore.State(),
        reducer: { LoginCore() }
      )
    )
    ToastView(message: "로그인에 실패했어요.")
    Spacer()
  }
}
