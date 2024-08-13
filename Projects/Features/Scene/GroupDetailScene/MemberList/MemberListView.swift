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

public struct MemberListView: View {
  private let store: StoreOf<MemberListCore>

  public init(store: StoreOf<MemberListCore>) {
    self.store = store
  }

  public var body: some View {
    VStack(spacing: 0) {
      NavigationBar(
        type: .titleWithBackButton("그룹원", .center),
        backButtonAction: {
          store.send(.backButtonTapped)
        }
      )
      .padding(.bottom, 8)
      
      ForEach(store.memberList?.members ?? [], id: \.id) { member in
        MemberView(
          member: member,
          groupKeyword: store.groupKeyword
        )
      }

      VStack(spacing: 0) {
        Text(store.inviteMemberMessage)
          .font(.body14)
          .foregroundStyle(DesignSystem.Colors.gray60)
          .padding(.bottom, 12)
        
        SmallButton(
          type: store.isFullCapacity ? .inactive : .active,
          smallButtonContentType: .copyCode
        ) {
          store.send(.copyCodeButtonTapped)
        }
      }
      .padding(.top, 102)
      
      Spacer()
    }
    .onAppear { store.send(.onAppear) }
  }
}

#Preview {
  MemberListView(
    store: Store(
      initialState: .init(
        groupID: 0,
        memberList: .mock,
        groupKeyword: .company
      ),
      reducer: MemberListCore.init
    )
  )
}
