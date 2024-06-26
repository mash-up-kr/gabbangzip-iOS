//
//  SmallPopupButton.swift
//  DesignSystem
//
//  Created by GREEN on 6/25/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import SwiftUI

// MARK: - 팝업 버튼
public struct SmallPopupButton: View {
  private var type: SmallPopupButtonType
  private var title: String
  private var action: () -> Void
  
  public init(
    type: SmallPopupButtonType,
    title: String,
    action: @escaping () -> Void = {}
  ) {
    self.type = type
    self.title = title
    self.action = action
  }
  
  public var body: some View {
    Button(
      action: {
        action()
      },
      label: {
        HStack(spacing: 0) {
          Spacer()
          
          Text(title)
            .font(.body14)
            .foregroundStyle(type.titleColor)
          
          Spacer()
        }
        .padding(.vertical, 18)
        .background(type.backgroundColor)
        .cornerRadius(12)
      }
    )
    .frame(width: 145, height: 50)
  }
}

// MARK: - DS에 따른 팝업 버튼 타입 종류
public enum SmallPopupButtonType {
  case active
  case secondary
  
  var titleColor: Color {
    switch self {
    case .active:
      return DesignSystem.Colors.gray0
    case .secondary:
      return DesignSystem.Colors.gray80
    }
  }
  
  var backgroundColor: Color {
    switch self {
    case .active:
      return DesignSystem.Colors.gray80
    case .secondary:
      return DesignSystem.Colors.gray40
    }
  }
}

#Preview {
  VStack {
    SmallPopupButton(type: .secondary, title: "나가기")
    SmallPopupButton(type: .active, title: "계속 작성하기")
  }
}
