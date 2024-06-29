//
//  PopupView.swift
//  DesignSystem
//
//  Created by GREEN on 6/29/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import SwiftUI

public struct PopupView: View {
  private let title: String
  private let description: String?
  private let leftButtonTitle: String
  private let leftButtonAction: () -> Void
  private let rightButtonTitle: String
  private let rightButtonAction: () -> Void
  
  public init(
    title: String,
    description: String? = nil,
    leftButtonTitle: String,
    leftButtonAction: @escaping () -> Void = {},
    rightButtonTitle: String,
    rightButtonAction: @escaping () -> Void = {}
  ) {
    self.title = title
    self.description = description
    self.leftButtonTitle = leftButtonTitle
    self.leftButtonAction = leftButtonAction
    self.rightButtonTitle = rightButtonTitle
    self.rightButtonAction = rightButtonAction
  }
  
  public var body: some View {
    VStack(spacing: 0) {
      Text(title)
        .font(.head16)
        .foregroundStyle(DesignSystem.Colors.gray80)
      
      if let description = description {
        Text(description)
          .font(.body14)
          .foregroundStyle(DesignSystem.Colors.gray60)
          .padding(.top, 10)
      }
      
      HStack(spacing: 8) {
        BottomButton(
          title: leftButtonTitle,
          isLeftButton: true,
          action: leftButtonAction
        )
        
        BottomButton(
          title: rightButtonTitle,
          isLeftButton: false,
          action: rightButtonAction
        )
      }
      .padding(.top, 26)
      .padding(.horizontal, 16)
    }
    .padding(.top, 30)
    .padding(.bottom, 18)
    .background(DesignSystem.Colors.gray20)
    .cornerRadius(20)
    .padding(.horizontal, 16)
  }
}

// MARK: - 동작 버튼
private struct BottomButton: View {
  private let title: String
  private let isLeftButton: Bool
  private let action: () -> Void
  private var titleColor: Color {
    isLeftButton ? DesignSystem.Colors.gray80 : DesignSystem.Colors.gray0
  }
  private var backgroundColor: Color {
    isLeftButton ? DesignSystem.Colors.gray40 : DesignSystem.Colors.gray80
  }
  
  fileprivate init(
    title: String,
    isLeftButton: Bool = true,
    action: @escaping () -> Void = { }
  ) {
    self.title = title
    self.isLeftButton = isLeftButton
    self.action = action
  }
  
  fileprivate var body: some View {
    HStack {
      Spacer()
      
      Text(title)
        .font(.body14)
        .foregroundStyle(titleColor)
      
      Spacer()
    }
    .padding(.vertical, 18)
    .background(backgroundColor)
    .cornerRadius(12)
  }
}

#Preview {
  VStack {
    PopupView(
      title: "나가실건가요?",
      description: "페이지를 나가면 작성중인 내용이 삭제돼요.",
      leftButtonTitle: "나가기",
      rightButtonTitle: "계속 작성하기"
    )
  }
}
