//
//  GabbangzipApp.swift
//  App
//
//  Created by gabbangzip on 5/20/24.
//

import ComposableArchitecture
import SwiftUI

@main
struct GabbangzipApp: App {
  @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
  
  var body: some Scene {
    WindowGroup {
      RootView(
        store: Store(
          initialState: RootCore.State(),
          reducer: RootCore.init
        )
      )
    }
  }
}
