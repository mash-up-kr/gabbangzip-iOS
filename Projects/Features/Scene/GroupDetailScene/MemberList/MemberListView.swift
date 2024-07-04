//
//  MemberListView.swift
//  GroupDetail
//
//  Created by 최혜린 on 6/22/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import ComposableArchitecture
import DesignSystem
import Models
import SwiftUI

struct MemberListView: View {
  private let store: StoreOf<MemberListCore>

  init(store: StoreOf<MemberListCore>) {
    self.store = store
  }

  var body: some View {
    VStack(spacing: 0) {
      NavigationBar(
        type: .titleWithBackButton("그룹원"),
        backButtonAction: {
          store.send(.backButtonDidTap)
        }
      )
      .padding(.bottom, 8)
      
      ForEach(store.memberList) { member in
        MemberView(
          member: member,
          groupCategory: store.groupCategory
        )
      }

      VStack(spacing: 0) {
        Text("그룹원을 추가하고 싶으세요?")
          .font(.body14)
          .foregroundStyle(DesignSystem.Colors.gray50)
          .padding(.bottom, 12)
        
        SmallButton(
          type: .constant(.active),
          smallButtonContentType: .copyLink
        ) {
          store.send(.copyLinkButtonDidTap)
        }
      }
      .padding(.top, 102)
      
      Spacer()
    }
  }
}

#Preview {
  MemberListView(
    store: Store(
      initialState: 
        MemberListCore.State(
          memberList: Member.mockList,
          inviteLink: "링크테스트 ⭐️",
          groupCategory: .club
        )
    ) {
      MemberListCore()
    }
  )
}
