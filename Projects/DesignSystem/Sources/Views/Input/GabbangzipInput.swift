//
//  GabbangzipInput.swift
//  DesignSystem
//
//  Created by GREEN on 6/18/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import SwiftUI

public struct GabbangzipInput: View {
  @Binding private var text: String
  private var placeholderText: String
  private var maxLength: Int
  @FocusState private var isFocused: Bool
  
  public init(
    text: Binding<String>,
    placeholderText: String,
    maxLength: Int
  ) {
    self._text = text
    self.placeholderText = placeholderText
    self.maxLength = maxLength
  }
  
  public var body: some View {
    TextField(
      text: $text,
      label: {
        Text(placeholderText)
          .font(.body16)
          .foregroundStyle(DesignSystem.Colors.gray60)
      }
    )
    .font(.body16)
    .foregroundStyle(DesignSystem.Colors.gray100)
    .padding(.vertical, 18)
    .padding(.horizontal, 20)
    .background(DesignSystem.Colors.gray40)
    .cornerRadius(10)
    .overlay{
      RoundedRectangle(cornerRadius: 10)
        .stroke(DesignSystem.Colors.gray50, lineWidth: 1)
    }
    .focused($isFocused)
    .onTapGesture {
      self.isFocused = true
    }
    .onChange(of: text) { _, newValue in
      if newValue.count > maxLength {
        text = String(newValue.prefix(maxLength))
      }
    }
  }
}

#Preview {
  VStack {
    GabbangzipInput(text: .constant(""), placeholderText: "placeholder", maxLength: 10)
    GabbangzipInput(text: .constant("test"), placeholderText: "placeholder", maxLength: 10)
  }
}
