//
//  ToastModifier.swift
//  DesignSystem
//
//  Created by GREEN on 6/29/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import SwiftUI

public struct ToastModifier: ViewModifier {
  @Binding var isPresented: Bool
  let type: ToastType
  
  public func body(content: Content) -> some View {
    if isPresented {
      content
        .overlay(
          content: {
            VStack(spacing: 0) {
              ToastView(type: type)
                .padding(.top, 15)
                .animation(.spring(), value: isPresented)
              
              Spacer()
            }
          }
        )
    }
  }
}

public extension View {
  func toast(
    isPresented: Binding<Bool>,
    type: ToastType
  ) -> some View {
    self.modifier(
      ToastModifier(
        isPresented: isPresented,
        type: type
      )
    )
  }
}
