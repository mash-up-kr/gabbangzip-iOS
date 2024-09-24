//
//  GroupListView.swift
//  Main
//
//  Created by YangJoonHyeok on 9/25/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

public struct GroupListView: View {
  let store: StoreOf<GroupListCore>
  
  public init(store: StoreOf<GroupListCore>) {
    self.store = store
  }
  
  public var body: some View {
    ScrollView {
      LazyVStack {
        ForEach(store.scope(state: \.groups, action: \.groups)) { childStore in
          GroupView(store: childStore)
        }
      }
    }
  }
}

#Preview {
  GroupListView(
    store: Store(
      initialState: .init(),
      reducer: GroupListCore.init
    )
  )
}
