//
//  VoteCompleteView.swift
//  GroupDetail
//
//  Created by 최혜린 on 7/6/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import ComposableArchitecture
import DesignSystem
import SwiftUI

struct VoteCompleteView: View {
  private let store: StoreOf<VoteCompleteCore>

  init(store: StoreOf<VoteCompleteCore>) {
    self.store = store
  }

  var body: some View {
    VStack {
      Spacer()
      
      Text("내 PIC을 골랐어요!")
        .font(.head20)
      // TODO: 색상 확인 후 변경 필요
        .foregroundStyle(DesignSystem.Colors.gray80)
        .padding(.bottom, 16)
      
      Text("모든 사람이 PIC을 완료하면\n네컷 사진이 만들어져요")
        .font(.body14)
      // TODO: 색상 확인 후 변경 필요
        .foregroundStyle(DesignSystem.Colors.gray60)
        .multilineTextAlignment(.center)
        .padding(.bottom, 24)
      
      // TODO: 랜덤 이미지 프레임 씌운 view로 변경
      RoundedRectangle(cornerRadius: 10)
        .foregroundStyle(.red)
        .frame(width: 240, height: 240)
        .padding(.horizontal, 76)
      
      Spacer()
      Spacer()
      
      GabbangzipBottomButton(
        type: .active,
        title: "완료",
        action: {
          store.send(.completeButtonTapped)
        }
      )
      .padding(.horizontal, 21)
    }
  }
}

#Preview {
  VoteCompleteView(
    store: Store(initialState: .init()) {
      VoteCompleteCore()
    }
  )
}
