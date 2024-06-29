//
//  PopupViewModifier.swift
//  DesignSystem
//
//  Created by GREEN on 6/29/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import SwiftUI

public struct PopupViewModifier: ViewModifier {
  @Binding var isPresented: Bool
  let title: String
  let description: String?
  let leftButtonTitle: String
  let leftButtonAction: () -> Void
  let rightButtonTitle: String
  let rightButtonAction: () -> Void

  public func body(content: Content) -> some View {
    if isPresented {
      ZStack {
        content
        
        VStack {
          Spacer()
          
          PopupView(
            title: title,
            description: description,
            leftButtonTitle: leftButtonTitle,
            leftButtonAction: leftButtonAction,
            rightButtonTitle: rightButtonTitle,
            rightButtonAction: rightButtonAction
          )
          
          Spacer()
        }
        .background(DesignSystem.Colors.gray100.opacity(0.5))
      }
    }
  }
}

public extension View {
  func popup(
    isPresented: Binding<Bool>,
    title: String,
    description: String? = nil,
    leftButtonTitle: String,
    leftButtonAction: @escaping () -> Void,
    rightButtonTitle: String,
    rightButtonAction: @escaping () -> Void
  ) -> some View {
    self.modifier(
      PopupViewModifier(
        isPresented: isPresented,
        title: title,
        description: description,
        leftButtonTitle: leftButtonTitle,
        leftButtonAction: leftButtonAction,
        rightButtonTitle: rightButtonTitle,
        rightButtonAction: rightButtonAction
      )
    )
  }
}
