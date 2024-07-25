//
//  MyPageCoordinatorView.swift
//  MyPageCoordinator
//
//  Created by YangJoonHyeok on 7/21/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import ComposableArchitecture
import MyPage
import SwiftUI
import TCACoordinators

public struct MyPageCoordinatorView: View {
  let store: StoreOf<MyPageCoordinatorCore>
  
  public init(store: StoreOf<MyPageCoordinatorCore>) {
    self.store = store
  }
  
  public var body: some View {
    TCARouter(store.scope(state: \.routes, action: \.router)) { screen in
      switch screen.case {
      case let .myPage(store):
        MyPageView(store: store)
      }
    }
  }
}
