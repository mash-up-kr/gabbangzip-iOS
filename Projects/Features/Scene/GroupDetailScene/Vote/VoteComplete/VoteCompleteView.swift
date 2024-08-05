//
//  VoteCompleteView.swift
//  GroupDetail
//
//  Created by 최혜린 on 7/6/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import ComposableArchitecture
import DesignSystem
import Models
import SwiftUI

public struct VoteCompleteView: View {
  private let store: StoreOf<VoteCompleteCore>

  init(store: StoreOf<VoteCompleteCore>) {
    self.store = store
  }

  public var body: some View {
    VStack(spacing: 0) {
      Spacer()
      
      Text("내 PIC을 골랐어요!")
        .font(.head20)
        .foregroundStyle(DesignSystem.Colors.gray80)
        .padding(.bottom, 16)
      
      Text("모든 사람이 PIC을 완료하면\n네컷 사진이 만들어져요")
        .font(.body14)
        .foregroundStyle(DesignSystem.Colors.gray60)
        .multilineTextAlignment(.center)
        .padding(.bottom, 24)
      
      PhotoWithFrame(
        keyword: store.voteResult.keyword,
        imageURLString: store.imageURLString,
        isBackgroundClear: true
      )
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
      .padding(.bottom, 15)
    }
    .onAppear {
      store.send(.onAppear)
    }
  }
}

#Preview {
  VoteCompleteView(
    store: Store(initialState: .init(
        voteResult: VoteCompleteInfo.mock,
        imageURLString: "https://24ai.tech/ru/wp-content/uploads/sites/4/2023/10/01_product_1_sdelat-kvadratnym-scaled.jpg"
      )
    ) {
      VoteCompleteCore()
    }
  )
}
