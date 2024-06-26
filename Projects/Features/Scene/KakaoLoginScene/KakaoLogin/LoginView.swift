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

public struct LoginView: View {
  public let store: StoreOf<LoginCore>
  
  public init(store: StoreOf<LoginCore>) {
    self.store = store
  }
  
  public var body: some View {
    ZStack {
      if let errorMessage = store.errorMessage {
        VStack {
          ToastView(message: errorMessage)
            .onAppear {
              DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                store.send(.hideError)
              }
            }
          Spacer()
        }
      }
      
      ZStack {
        LottieView(
          type: .login,
          loopMode: .repeat(1)
        )
        .frame(maxWidth: .infinity)
        VStack {
          Spacer()
            .frame(height: 80)
          DesignSystem.Icons.Login.logo
            .resizable()
            .scaledToFit()
            .frame(width: 100)
          Spacer()
            .frame(height: 40)
          Text("우리가 픽! 하는\n우리끼리 네컷앨범")
            .font(.text22)
            .multilineTextAlignment(.center)
            .foregroundStyle(DesignSystem.Colors.gray80)
            .padding()
          Spacer()
          Button(
            action: {
              store.send(.loginButtonTapped)
            },
            label: {
              DesignSystem.Icons.Login.kakao
                .resizable()
                .scaledToFit()
                .padding(.horizontal, 16)
                .padding(.bottom, 40)
                .frame(width: UIScreen.main.bounds.size.width)
            }
          )
        }
      }
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
//    ToastView(message: "로그인에 실패했어요.")
    Spacer()
  }
}
