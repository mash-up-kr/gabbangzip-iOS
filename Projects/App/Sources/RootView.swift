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
      LottieView(
        type: .login,
        loopMode: .repeat(1)
      )
      .frame(width: 600)
      LoginView(
        store: store.scope(
          state: \.login,
          action: \.login
        )
      )
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
