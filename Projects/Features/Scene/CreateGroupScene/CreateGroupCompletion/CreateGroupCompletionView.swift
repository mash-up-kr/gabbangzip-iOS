//
//  CreateGroupCompletionView.swift
//  CreateGroup
//
//  Created by YangJoonHyeok on 8/1/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import ComposableArchitecture
import DesignSystem
import Models
import NukeUI
import SwiftUI
import Lovebug

public struct CreateGroupCompletionView: View {
  @Bindable var store: StoreOf<CreateGroupCompletionCore>
  
  public init(store: StoreOf<CreateGroupCompletionCore>) {
    self.store = store
  }
  
  public var body: some View {
    VStack(spacing: 0) {
      NavigationBar(type: .title("완료"))
      
      PICProgressView(progress: 1.0)
        .padding(.horizontal, 16)
      
      Text("그룹에 친구들을 추가하고\n추억을 함께 PIC 해보세요")
        .font(.head18)
        .foregroundStyle(DesignSystem.Colors.gray80)
        .padding(.horizontal, 16)
        .padding(.vertical, 32)
      
      PhotoCard(status: store.createdGroupInfo.keyword.convertToPhotoCardStatus()) {
        VStack(spacing: 0) {
          Tag(type: store.createdGroupInfo.keyword.tagType)
          
          PhotoWithFrame(
            keyword: store.createdGroupInfo.keyword,
            foregroundColor: store.createdGroupInfo.keyword.foregroundColor,
            imageURLString: store.imageURLString
          )
          .padding(.init(top: 24, leading: 30, bottom: 26, trailing: 30))
            
          
          Text(store.createdGroupInfo.groupName)
            .font(.head20)
            .foregroundStyle(DesignSystem.Colors.gray80)
            .padding(.bottom, 12)
        }
      }
      .padding(.horizontal, 42)
      
      Text("그룹원은 최대 6명까지 초대 가능해요.")
        .font(.text14)
        .foregroundStyle(DesignSystem.Colors.gray60)
        .padding(.top, 16)
      
      SmallButton(type: .active, smallButtonContentType: .copyLink, action: { store.send(.copyLinkButtonTapped) })
        .padding(.top, 8)
      
      Spacer()
      
      GabbangzipBottomButton(
        type: .active,
        title: "완료",
        action: { store.send(.completeButtonTapped) }
      )
      .padding(.horizontal, 16)
      .padding(.bottom, 12)
    }
    .onAppear { store.send(.onAppear) }
    .toast(
      isPresented: $store.toastPresented.sending(\.setToastPresented),
      type: .textWithCheckIcon("링크를 복사했어요.")
    )
  }
}

#Preview {
  CreateGroupCompletionView(
    store: Store(
      initialState: .init(
        createdGroupInfo: CreatedGroupInfo(
          id: 0,
          groupName: "test",
          keyword: .company,
          groupImageURL: "pic/9c8f3f24-6ed2-4a2e-8af5-52aeff93b230.jpeg",
          invitationCode: "ttat"
        ),
        imageURLString: "https://pic-api-bucket.s3.ap-northeast-2.amazonaws.com/pic/9c8f3f24-6ed2-4a2e-8af5-52aeff93b230.jpeg"
      ),
      reducer: CreateGroupCompletionCore.init
    )
  )
}
