//
//  SelectKeywordView.swift
//  CreateGroup
//
//  Created by YangJoonHyeok on 7/9/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import ComposableArchitecture
import DesignSystem
import SwiftUI

public struct SelectKeywordView: View {
  @Bindable private var store: StoreOf<SelectKeywordCore>

  public init(store: StoreOf<SelectKeywordCore>) {
    self.store = store
  }

  public var body: some View {
    VStack(spacing: 0) {
      NavigationBar(
        type: .titleWithBackButton("그룹 만들기"),
        backButtonAction: { store.send(.backButtonTapped) }
      )
      
      PICProgressView(progress: 0.5)
        .padding(.horizontal, 16)
      
      Text("그룹의 키워드를 선택해 주세요")
        .font(.head18)
        .foregroundStyle(DesignSystem.Colors.gray80)
        .padding(.horizontal, 16)
        .padding(.vertical, 24)
      
      LazyVGrid(
        columns: [
          GridItem(.flexible(), spacing: 16),
          GridItem(.flexible(), spacing: 16),
          GridItem(.flexible(), spacing: 16)
        ],
        content: {
          KeywordButton(
            type: .school,
            isSelected: $store.schoolKeywordButtonSelected.sending(\.schoolKeywordButtonTapped)
          )
          
          KeywordButton(
            type: .crew,
            isSelected: $store.crewKeywordButtonSelected.sending(\.crewKeywordButtonTapped)
          )
          
          KeywordButton(
            type: .company,
            isSelected: $store.companyKeywordButtonSelected.sending(\.companyKeywordButtonTapped)
          )
          
          KeywordButton(
            type: .littleMoim,
            isSelected: $store.littleMoimKeywordButtonSelected.sending(\.littleMoimKeywordButtonTapped)
          )
          
          KeywordButton(
            type: .network,
            isSelected: $store.networkKeywordButtonSelected.sending(\.networkKeywordButtonTapped)
          )
          
          KeywordButton(
            type: .exercise,
            isSelected: $store.exerciseKeywordButtonSelected.sending(\.exerciseKeywordButtonTapped)
          )
          
          KeywordButton(
            type: .hobby,
            isSelected: $store.hobbyKeywordButtonSelected.sending(\.hobbyKeywordButtonTapped)
          )
        }
      )
      .padding(.horizontal, 16)
      
      Spacer()
      
      GabbangzipBottomButton(
        type: .active,
        title: "다음",
        action: { store.send(.nextButtonTapped) }
      )
      .padding(.horizontal, 16)
      .padding(.bottom, 12)
    }
  }
}

#Preview {
  SelectKeywordView(
    store: Store(
      initialState: .init(groupName: "test"),
      reducer: SelectKeywordCore.init
    )
  )
}
