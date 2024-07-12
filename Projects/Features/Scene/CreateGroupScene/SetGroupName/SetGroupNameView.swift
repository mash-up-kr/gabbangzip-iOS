//
//  SetGroupNameView.swift
//  CreateGroup
//
//  Created by YangJoonHyeok on 7/9/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import ComposableArchitecture
import DesignSystem
import SwiftUI

public struct SetGroupNameView: View {
  @Bindable private var store: StoreOf<SetGroupNameCore>

  public init(store: StoreOf<SetGroupNameCore>) {
    self.store = store
  }

  public var body: some View {
    VStack(spacing: 0) {
      NavigationBar(
        type: .titleWithBackButton("그룹 만들기"),
        backButtonAction: { store.send(.backButtonTapped) }
      )
      
      PICProgressView(progress: 0.25)
        .padding(.horizontal, 16)
      
      VStack(spacing: 16) {
        HStack {
          Text("그룹의 이름은 무엇인가요?")
            .font(.head18)
            .foregroundStyle(DesignSystem.Colors.gray80)
          
          Spacer()
        }
        
        GabbangzipInput(
          text: $store.text.sending(\.textChanged),
          placeholderText: "최대 10자 까지 입력 가능해요.",
          maxLength: 10
        )
      }
      .padding(.horizontal, 16)
      .padding(.top, 24)
      
      Spacer()
      
      GabbangzipBottomButton(
        type: store.nextButtonType,
        title: "다음",
        action: { store.send(.nextButtonTapped) }
      )
      .padding(.horizontal, 16)
      .padding(.bottom, 12)
    }
  }
}

#Preview {
  SetGroupNameView(
    store: Store(
      initialState: .init(),
      reducer: SetGroupNameCore.init
    )
  )
}
