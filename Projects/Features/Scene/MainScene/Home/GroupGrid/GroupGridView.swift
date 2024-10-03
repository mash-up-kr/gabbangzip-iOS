//
//  GroupGridView.swift
//  Main
//
//  Created by YangJoonHyeok on 9/25/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import ComposableArchitecture
import Models
import SwiftUI

public struct GroupGridView: View {
  let store: StoreOf<GroupGridCore>
  
  public init(store: StoreOf<GroupGridCore>) {
    self.store = store
  }
  
  public var body: some View {
    ScrollView {
      LazyVGrid(
        columns: [
          GridItem(.flexible(), spacing: 22),
          GridItem(.flexible(), spacing: 22),
        ],
        spacing: 18,
        content: {
          ForEach(store.scope(state: \.groupGridItems, action: \.groupGridItems)) { childStore in
            GroupGridItemView(store: childStore)
          }
        }
      )
      .padding(.horizontal, 16)
      .padding(.top, 18)
    }
  }
}

#Preview {
  GroupGridView(
    store: Store(
      initialState: GroupGridCore.State.init(groupGridItems: [
        GroupGridItemCore.State(
          id: 1,
          name: "test1",
          keyword: .company,
          statusDescription: "hi",
          cardFrontImageURL: "",
          s3BucketDomain: ""
        ),
        GroupGridItemCore.State(
          id: 2,
          name: "test2",
          keyword: .company,
          statusDescription: "hi",
          cardFrontImageURL: "",
          s3BucketDomain: ""
        ),
        GroupGridItemCore.State(
          id: 3,
          name: "test3",
          keyword: .company,
          statusDescription: "hi",
          cardFrontImageURL: "",
          s3BucketDomain: ""
        ),
        GroupGridItemCore.State(
          id: 4,
          name: "test4",
          keyword: .company,
          statusDescription: "hi",
          cardFrontImageURL: "",
          s3BucketDomain: ""
        ),
        GroupGridItemCore.State(
          id: 5,
          name: "test5",
          keyword: .company,
          statusDescription: "hi",
          cardFrontImageURL: "",
          s3BucketDomain: ""
        )
      ]),
      reducer: GroupGridCore.init
    )
  )
}
