//
//  ContentView.swift
//  App
//
//  Created by gabbangzip on 5/20/24.
//

import DesignSystem
import SwiftUI
import ComposableArchitecture

public struct ContentView: View {
  public let store: StoreOf<GabbangzipCore>
  
  public init(store: StoreOf<GabbangzipCore>) {
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
  ContentView(store: .init(initialState: GabbangzipCore.State(), reducer: { GabbangzipCore() }))
}
