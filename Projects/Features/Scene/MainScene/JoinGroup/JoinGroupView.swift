//
//  JoinGroupView.swift
//  Main
//
//  Created by YangJoonHyeok on 7/29/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import ComposableArchitecture
import DesignSystem
import SwiftUI

public struct JoinGroupView: View {
  @Bindable var store: StoreOf<JoinGroupCore>
  
  public init(store: StoreOf<JoinGroupCore>) {
    self.store = store
  }
  
  public var body: some View {
    VStack(spacing: 0) {
      NavigationBar(
        type: .titleWithBackButton("그룹 들어가기", .center),
        backButtonAction: { store.send(.backButtonTapped) }
      )
      
      Text("초대코드를 입력해주세요")
        .font(.head18)
        .foregroundStyle(DesignSystem.Colors.gray80)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.init(top: 32, leading: 16, bottom: 16, trailing: 16))
      
      GabbangzipInput(
        text: $store.text.sending(\.textChanged),
        placeholderText: "예) A12B0EHQ",
        maxLength: 8
      )
      .padding(.horizontal, 16)
      
      Spacer()
      
      GabbangzipBottomButton(
        type: store.nextButtonType,
        title: "다음",
        action: { store.send(.nextButtonTapped) }
      )
      .padding(.horizontal, 16)
    }
    .toolbar(.hidden)
    .toast(
      isPresented: $store.toastPresented.sending(\.toastPresentedChanged),
      type: .textWithInfoIcon("존재하지 않는 초대코드예요.")
    )
  }
}

#Preview {
  JoinGroupView(
    store: Store(
      initialState: .init(isFromGetStarted: true),
      reducer: JoinGroupCore.init
    )
  )
}
