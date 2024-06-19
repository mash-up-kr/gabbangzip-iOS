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
      ContentView(store: .init(initialState: GabbangzipCore.State(), reducer: { GabbangzipCore() }))
    }
  }
}
