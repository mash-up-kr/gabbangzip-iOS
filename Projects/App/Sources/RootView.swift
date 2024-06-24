//
//  RootView.swift
//  App
//
//  Created by gabbangzip on 5/20/24.
//

import ComposableArchitecture
import DesignSystem
import SwiftUI

struct RootView: View {
  let store: StoreOf<RootCore>
  
  init(store: StoreOf<RootCore>) {
    self.store = store
  }
  
  var body: some View {
    ZStack {
      LottieView(type: .login,
                 loopMode: .repeat(1))
      .frame(width: 600)
      LoginView(store: store)
      
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
    }
    .onOpenURL { url in
      store.send(.onOpenURL(url))
    }
  }
}

struct LoginView: View {
  public let store: StoreOf<RootCore>
  
  public init(store: StoreOf<RootCore>) {
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

struct ToastView: View {
  let message: String
  
  var body: some View {
    HStack {
      Image(uiImage: DesignSystem.Icons.Login.loginIconUIImage)
        .resizable()
        .frame(width: 20, height: 20)
        .padding(.leading)
      Text(message)
        .foregroundColor(.white)
        .padding(.trailing)
    }
    .padding()
    .background(DesignSystem.Colors.gray60)
    .cornerRadius(40)
  }
}

#Preview {
  ZStack {
    RootView(
      store: Store(
        initialState: RootCore.State(),
        reducer: { RootCore() }
      )
    )
    ToastView(message: "로그인에 실패했어요.")
    Spacer()
  }
}
