//
//  GabbangzipButton.swift
//  DesignSystem
//
//  Created by GREEN on 6/18/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import SwiftUI

// MARK: - 하단 버튼
public struct GabbangzipBottomButton: View {
  @Binding private var type: ButtonType
  private var title: String
  private var action: () -> Void
  private var isEnabled: Bool {
    type != .inactive
  }
  
  public init(
    type: Binding<ButtonType>,
    title: String,
    action: @escaping () -> Void = {}
  ) {
    self._type = type
    self.title = title
    self.action = action
  }
  
  public var body: some View {
    Button(
      action: {
        if isEnabled {
          action()
        }
      },
      label: {
        HStack(spacing: 0) {
          Spacer()
          
          Text(title)
            .font(.body17)
            .foregroundStyle(type.titleColor)
          
          Spacer()
        }
        .padding(.vertical, 22)
        .background(type.backgroundColor)
        .cornerRadius(16)
      }
    )
    .disabled(!isEnabled)
  }
}

// MARK: - DS에 따른 하단 버튼 타입 종류
public enum ButtonType {
  case active
  case inactive
  case secondary
  
  var titleColor: Color {
    switch self {
    case .active, .inactive:
      return DesignSystem.Colors.gray0
    case .secondary:
      return DesignSystem.Colors.gray60
    }
  }
  
  var backgroundColor: Color {
    switch self {
    case .active:
      return DesignSystem.Colors.gray80
    case .inactive:
      return DesignSystem.Colors.gray60
    case .secondary:
      return DesignSystem.Colors.gray40
    }
  }
}
