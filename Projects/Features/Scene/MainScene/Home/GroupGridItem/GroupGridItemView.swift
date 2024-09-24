//
//  GroupGridItemView.swift
//  Main
//
//  Created by YangJoonHyeok on 9/25/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import ComposableArchitecture
import DesignSystem
import Lovebug
import Models
import NukeUI
import SwiftUI

public struct GroupGridItemView: View {
  let store: StoreOf<GroupGridItemCore>
  
  public init(store: StoreOf<GroupGridItemCore>) {
    self.store = store
  }
  
  public var body: some View {
    VStack(spacing: 8) {
      PhotoWithFrame(
        frameShape: store.keyword.frame,
        foregroundColor: DesignSystem.Colors.gray0,
        imageURLString: store.s3BucketDomain + store.cardFrontImageURL
      )
      
      Text(store.name)
        .font(.head16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .foregroundStyle(DesignSystem.Colors.gray80)
      
      HStack {
        Tag(type: store.keyword.tagType)
        
        Tag(type: .etc(.custom(store.statusDescription)))
        
        Spacer(minLength: 0)
      }
    }
  }
}

#Preview {
  GroupGridItemView(
    store: Store(
      initialState: GroupGridItemCore.State(
        id: 1,
        name: "test",
        keyword: .company,
        statusDescription: "hi",
        cardFrontImageURL: "",
        s3BucketDomain: ""
      ),
      reducer: GroupGridItemCore.init
    )
  )
}
