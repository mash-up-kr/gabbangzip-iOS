//
//  ContentView.swift
//  App
//
//  Created by gabbangzip on 5/20/24.
//

import DesignSystem
import SwiftUI
import ComposableArchitecture

public struct RootView: View {
  public let store: StoreOf<RootCore>
  
  public init(store: StoreOf<RootCore>) {
    self.store = store
  }
  
  public var body: some View {
    VStack {
      LottieView(type: .confetti)
        .frame(width: 500, height: 500)
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
