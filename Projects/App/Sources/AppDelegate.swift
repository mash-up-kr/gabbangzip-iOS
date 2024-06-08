//
//  AppDelegate.swift
//  App
//
//  Created by YangJoonHyeok on 6/8/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import ComposableArchitecture
import UIKit

final class AppDelegate: NSObject, UIApplicationDelegate {
  let store = StoreOf<AppDelegateReducer>.init(
    initialState: .init(),
    reducer: {
      AppDelegateReducer()
    }
  )
  
  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
  ) -> Bool {
    store.send(.didFinishLaunching)
    return true
  }
}
