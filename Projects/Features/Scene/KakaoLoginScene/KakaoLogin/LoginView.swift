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
              store.send(.checkDeadline(2))
            }
          
          Spacer()
        }
      }
      
      VStack {
        Spacer()
          .frame(height: 80)
        
        DesignSystem.Icons.picLogo
          .resizable()
          .scaledToFit()
          .frame(width: 100)
        
        Text("우리가 픽! 하는\n우리끼리 네컷앨범")
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
