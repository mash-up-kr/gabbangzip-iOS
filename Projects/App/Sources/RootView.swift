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
        Text("로그인이 되었습니다.")
      }
    }
    .onAppear {
      store.send(.checkAccessToken)
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
