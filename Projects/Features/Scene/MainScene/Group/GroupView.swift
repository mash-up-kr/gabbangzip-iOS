//
//  GroupView.swift
//  Main
//
//  Created by YangJoonHyeok on 8/8/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import ComposableArchitecture
import DesignSystem
import Lovebug
import Models
import NukeUI
import SwiftUI

public struct GroupView: View {
  @Bindable var store: StoreOf<GroupCore>
  
  public init(store: StoreOf<GroupCore>) {
    self.store = store
  }
  
  public var body: some View {
    VStack(spacing: 16) {
      if store.hasNoEvent {
        GroupHeaderView(
          title: store.name,
          isButtonStyle: false
        )
      } else {
        Button(
          action: { store.send(.headerButtonTapped) },
          label: {
            GroupHeaderView(
              title: store.name,
              isButtonStyle: true
            )
          }
        )
      }

      HStack {
        Tag(type: store.keyword.tagType)
        
        Tag(type: .etc(.custom(store.statusDescription)))
        
        Spacer(minLength: 0)
      }
      .padding(.horizontal, 16)
      
      GroupContentView(store: store)
      
      if !store.isLast {
        Divider()
          .frame(height: 8)
          .overlay(DesignSystem.Colors.gray20)
          .padding(.top, 8)
      }
    }
    .photosPicker(
      isPresented: $store.photosPickerPresented.sending(\.photosPickerPresentedChanged),
      selection: $store.selectedPickerItems.sending(\.selectedPickerItemsChanged),
      maxSelectionCount: 4,
      matching: .images
    )
  }
}

#Preview {
  GroupView(
    store: Store(
      initialState: .init(
        userInfo: Shared<UserInfo>.init(UserInfo(
          userID: 1,
          nickname: "james",
          accessToken: "",
          refreshToken: "",
          loginType: .apple
        )),
        id: 0,
        name: "test",
        keyword: GroupData.Keyword.company,
        status: GroupData.Status.eventCompleted,
        statusDescription: "hi",
        recentEvent: RecentEvent(
          id: 0, 
          name: "hi",
          date: "2024-07-05T00:00:00Z"
        ),
        cardFrontImageURL: "",
        cardBackImages: nil,
        isLast: false
      ),
      reducer: GroupCore.init
    )
  )
}
