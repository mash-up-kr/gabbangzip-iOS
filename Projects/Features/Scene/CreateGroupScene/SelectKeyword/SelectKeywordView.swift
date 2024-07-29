//
//  SelectKeywordView.swift
//  CreateGroup
//
//  Created by YangJoonHyeok on 7/9/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import ComposableArchitecture
import DesignSystem
import Models
import SwiftUI

public struct SelectKeywordView: View {
  @Bindable private var store: StoreOf<SelectKeywordCore>

  public init(store: StoreOf<SelectKeywordCore>) {
    self.store = store
  }

  public var body: some View {
    VStack(spacing: 0) {
      NavigationBar(
        type: .titleWithBackButton("그룹 만들기", .center),
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
          ForEach(GroupData.Keyword.allCases, id: \.self) { keyword in
            KeywordButton(
              type: keyword.categoryType,
              isSelected: Binding(
                get: {
                  switch keyword {
                  case .school:
                    return store.schoolKeywordButtonSelected
                  case .company:
                    return store.companyKeywordButtonSelected
                  case .crew:
                    return store.crewKeywordButtonSelected
                  case .network:
                    return store.networkKeywordButtonSelected
                  case .exercise:
                    return store.exerciseKeywordButtonSelected
                  case .hobby:
                    return store.hobbyKeywordButtonSelected
                  case .littleMoim:
                    return store.littleMoimKeywordButtonSelected
                  }
                },
                set: { isSelected in
                  switch keyword {
                  case .school:
                    store.send(.keywordButtonTapped(.school, isSelected))
                  case .company:
                    store.send(.keywordButtonTapped(.company, isSelected))
                  case .crew:
                    store.send(.keywordButtonTapped(.crew, isSelected))
                  case .network:
                    store.send(.keywordButtonTapped(.network, isSelected))
                  case .exercise:
                    store.send(.keywordButtonTapped(.exercise, isSelected))
                  case .hobby:
                    store.send(.keywordButtonTapped(.hobby, isSelected))
                  case .littleMoim:
                    store.send(.keywordButtonTapped(.littleMoim, isSelected))
                  }
                }
              )
            )
          }
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
