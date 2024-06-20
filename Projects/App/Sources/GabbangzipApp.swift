//
//  GabbangzipApp.swift
//  App
//
//  Created by gabbangzip on 5/20/24.
//

import SwiftUI
import ComposableArchitecture

@main
struct GabbangzipApp: App {
  @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
  
  var body: some Scene {
    WindowGroup {
      RootView(
        store: Store(
          initialState: RootCore.State(),
          reducer: { RootCore() }
        )
      )
    }
  }
}
