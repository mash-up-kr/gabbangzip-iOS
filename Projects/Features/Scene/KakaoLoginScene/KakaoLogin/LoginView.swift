//
//  LoginView.swift
//  KakaoLogin
//
//  Created by Hyun A Song on 6/24/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import ComposableArchitecture
import DesignSystem
import SwiftUI

public struct LoginView: View {
  @Bindable public var store: StoreOf<LoginCore>
  
  public init(store: StoreOf<LoginCore>) {
    self.store = store
  }
  
  public var body: some View {
    VStack {
      Spacer()
        .frame(height: 80)
      
      DesignSystem.Icons.picLogo
        .resizable()
        .scaledToFit()
        .frame(width: 100)
      
      Text(store.loginTitle)
        .font(.text22)
        .multilineTextAlignment(.center)
        .foregroundStyle(DesignSystem.Colors.gray80)
        .padding(.top, 28)
      
      Spacer()
      
      LottieView(
        type: .login,
        loopMode: .repeat(1)
      )
      .padding(.horizontal, 40)
      
      Spacer()
      
      Button(
        action: {
          store.send(.loginButtonTapped)
        },
        label: {
          DesignSystem.Icons.kakao
            .resizable()
            .scaledToFit()
            .padding(.horizontal, 16)
            .padding(.bottom, 60)
            .frame(width: UIScreen.main.bounds.size.width)
        }
      )
    }
    .toast(
      isPresented: $store.isPresented,
      type: .textWithInfoIcon(store.loginErrorMessage)
    )
  }
}

#Preview {
  LoginView(
    store: Store(
      initialState: LoginCore.State(),
      reducer: LoginCore.init
    )
  )
}
