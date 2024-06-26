//
//  GabbangzipToggle.swift
//  DesignSystem
//
//  Created by GREEN on 6/25/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import SwiftUI

public struct GabbangzipToggle: View {
  @Binding private var isOn: Bool
  private var onAction: () -> Void
  private var offAction: () -> Void
  
  public init(
    isOn: Binding<Bool> = .constant(false),
    onAction: @escaping () -> Void = {},
    offAction: @escaping () -> Void = {}
  ) {
    self._isOn = isOn
    self.onAction = onAction
    self.offAction = offAction
  }
  
  public var body: some View {
    Button(
      action: {
        isOn.toggle()
        isOn ? onAction() : offAction()
      }
    ) {
      RoundedRectangle(cornerRadius: 15.5)
        .fill(
          isOn
          ? DesignSystem.Colors.gray100
          : DesignSystem.Colors.gray40
        )
        .frame(width: 42, height: 26)
        .overlay(
          Circle()
            .fill(DesignSystem.Colors.gray0)
            .frame(width: 21, height: 21.6)
            .padding(2)
            .offset(x: isOn ? 8 : -8)
        )
        .animation(
          .easeInOut(duration: 0.2),
          value: isOn
        )
    }
    .buttonStyle(PlainButtonStyle())
  }
}

#Preview {
  HStack {
    GabbangzipToggle()
    GabbangzipToggle(isOn: .constant(true))
  }
}
