//
//  MyPageView.swift
//  MyPage
//
//  Created by Hyun A Song on 7/5/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import ComposableArchitecture
import DesignSystem
import SwiftUI

public struct MyPageView: View {
  let store: StoreOf<MyPageCore>
  
  public init(store: StoreOf<MyPageCore>) {
    self.store = store
  }
  
  public var body: some View {
    NavigationBar(type: .titleWithBackButton(store.myPageTitle))
    
    
  }
}

#Preview {
  MyPageView(
    store: Store(
      initialState: .init(nickname: "가빵집"),
      reducer: MyPageCore.init
    )
  )
}
