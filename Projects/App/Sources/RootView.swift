//
//  RootView.swift
//  App
//
//  Created by gabbangzip on 5/20/24.
//

import ComposableArchitecture
import DesignSystem
import KakaoLogin
import MyPage
import SwiftUI

struct RootView: View {
  let store: StoreOf<RootCore>
  
  init(store: StoreOf<RootCore>) {
    self.store = store
  }
  
  var body: some View {
    Group {
      if !store.isLogin {
        LoginView(
          store: store.scope(
            state: \.login,
            action: \.login
          )
        )
        .onOpenURL { url in
          store.send(.onOpenURL(url))
        }
      } else {
        MyPageView(
          store: Store(
            initialState: MyPageCore.State(nickname: store.nickname),
            reducer: MyPageCore.init
          )
        )
      }
    }
    .onAppear {
      store.send(.onAppear)
    }
  }
}

#Preview {
  RootView(
    store: Store(
      initialState: RootCore.State(),
      reducer: RootCore.init
    )
  )
}
