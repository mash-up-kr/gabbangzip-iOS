//
//  RootView.swift
//  App
//
//  Created by gabbangzip on 5/20/24.
//

import ComposableArchitecture
import DesignSystem
import KakaoLogin
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

#Preview {
  RootView(
    store: Store(
      initialState: RootCore.State(),
      reducer: { RootCore() }
    )
  )
}
