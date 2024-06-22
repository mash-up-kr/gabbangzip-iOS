//
//  MemberListView.swift
//  GroupDetail
//
//  Created by 최혜린 on 6/22/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

public struct MemberListView: View {
  let store: StoreOf<MemberListCore>

  public init(store: StoreOf<MemberListCore>) {
    self.store = store
  }

  public var body: some View {
    Text("Hello, World!")
  }
}

#Preview {
  MemberListView(
    store: Store(initialState: .init()) {
      MemberListCore()
    }
  )
}
