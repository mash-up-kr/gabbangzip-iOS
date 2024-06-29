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
  let time: CGFloat
  
  public func body(content: Content) -> some View {
    content
      .overlay(
        content: {
          VStack(spacing: 0) {
            ToastView(type: type)
              .padding(.top, 15)
              .transition(.opacity)
              .animation(.spring(), value: isPresented)
            
            Spacer()
          }
          .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + time) {
              withAnimation {
                isPresented = false
              }
            }
          }
          .opacity(isPresented ? 1 : 0)
        }
      )
  }
}

public extension View {
  func toast(
    isPresented: Binding<Bool>,
    type: ToastType,
    time: CGFloat = 2.0
  ) -> some View {
    self.modifier(
      ToastModifier(
        isPresented: isPresented,
        type: type,
        time: time
      )
    )
  }
}
