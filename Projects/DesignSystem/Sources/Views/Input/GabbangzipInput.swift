//
//  GabbangzipInput.swift
//  DesignSystem
//
//  Created by GREEN on 6/18/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import SwiftUI

public struct GabbangzipInput: View {
  @Binding private var type: InputType
  @Binding private var text: String
  private var placeholderText: String
  private var maxLength: Int
  
  public init(
    type: Binding<InputType> = .constant(.default),
    text: Binding<String>,
    placeholderText: String,
    maxLength: Int
  ) {
    self._type = type
    self._text = text
    self.placeholderText = placeholderText
    self.maxLength = maxLength
  }
  
  public var body: some View {
    TextField(
      placeholderText,
      text: $text
    )
    .font(.body16)
    .foregroundStyle(type.textColor)
    .padding(.vertical, 20)
    .padding(.leading, 20)
    .background(DesignSystem.Colors.gray40)
    .cornerRadius(10)
    .onChange(of: text) { _, newValue in
      if newValue.count > maxLength {
        text = String(newValue.prefix(maxLength))
      } else if !newValue.isEmpty {
        type = .active
      } else {
        type = .default
      }
    }
  }
}

// MARK: - DS에 따른 인풋 타입 종류
public enum InputType {
  case `default`
  case active
  
  var textColor: Color {
    switch self {
    case .default:
      return DesignSystem.Colors.gray60
    case .active:
      return DesignSystem.Colors.gray100
    }
  }
}

#Preview {
  VStack {
    GabbangzipInput(type: .constant(.active), text: .constant("test"), placeholderText: "placeholder", maxLength: 10)
    
    GabbangzipInput(type: .constant(.default), text: .constant("test"), placeholderText: "placeholder", maxLength: 10)
  }
}
