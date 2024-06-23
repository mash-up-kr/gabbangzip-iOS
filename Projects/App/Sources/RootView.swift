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
          Image(uiImage: DesignSystem.Icons.Login.kakaoUIImage)
            .resizable()
            .scaledToFit()
            .frame(width: 350)
        })
      }
    }
  }
  
  struct ToastView: View {
    let message: String
    
    var body: some View {
      Text(message)
        .foregroundColor(.white)
        .padding()
        .background(DesignSystem.Colors.gray60)
        .cornerRadius(40)
        .padding()
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
