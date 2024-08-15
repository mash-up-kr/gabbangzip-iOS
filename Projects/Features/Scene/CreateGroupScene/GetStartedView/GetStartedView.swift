//
//  GetStartedView.swift
//  CreateGroup
//
//  Created by YangJoonHyeok on 7/9/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import ComposableArchitecture
import DesignSystem
import SwiftUI

public struct GetStartedView: View {
  private let store: StoreOf<GetStartedCore>

  public init(store: StoreOf<GetStartedCore>) {
    self.store = store
  }

  public var body: some View {
    GeometryReader { geometry in
      VStack(spacing: 0) {
        Text("내 친구들과\n그룹을 만들어\nPIC과 함께해 볼까요?")
          .font(.head20)
          .multilineTextAlignment(.center)
          .foregroundStyle(DesignSystem.Colors.gray80)
          .padding(.top, 84)
          .padding(.bottom, 108)
        
        LottieView(
          type: .morphing,
          loopMode: .loop
        )
        .frame(width: geometry.size.width - 229, height: geometry.size.width - 229)
        
        Spacer()
        
        Text("초대 링크를 받으셨나요?\n링크를 눌러 바로 그룹에 들어갈 수 있어요.")
          .font(.body14)
          .multilineTextAlignment(.center)
          .foregroundStyle(DesignSystem.Colors.gray60)
          .padding(.bottom, 16)
        
        
        GabbangzipBottomButton(
          type: .active,
          title: "그룹 만들기",
          action: { store.send(.createGroupButtonTapped) }
        )
        .padding(.horizontal, 16)
        .padding(.bottom, 12)
      }
    }
  }
}

#Preview {
  GetStartedView(
    store: Store(
      initialState: .init(),
      reducer: GetStartedCore.init
    )
  )
}
