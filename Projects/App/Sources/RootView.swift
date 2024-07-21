//
//  RootView.swift
//  App
//
//  Created by gabbangzip on 5/20/24.
//

import ComposableArchitecture
import DesignSystem
import Login
import MainCoordinator
import SwiftUI

struct RootView: View {
  @Bindable var store: StoreOf<RootCore>
  
  init(store: StoreOf<RootCore>) {
    self.store = store
  }
  
  var body: some View {
    Group {
      switch store.destination {
      case .login:
        if let store = store.scope(state: \.destination?.login, action: \.destination.login) {
          LoginView(store: store)
        }
      case .mainCoordinator:
        if let store = store.scope(state: \.destination?.mainCoordinator, action: \.destination.mainCoordinator) {
          MainCoordinatorView(store: store)
        }
      case .none:
        Text("Launching...")
      }
    }
    .onAppear { store.send(.onAppear) }
    .onOpenURL { url in
      store.send(.onOpenURL(url))
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
