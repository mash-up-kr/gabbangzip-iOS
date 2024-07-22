//
//  DraggableViewModifier.swift
//  Common
//
//  Created by 최혜린 on 7/22/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import SwiftUI

public enum SwipeDirection {
  case left
  case right
}

public struct DraggableViewModifier: ViewModifier {
  @Binding var isActive: (Bool, SwipeDirection)
  @State private var translation: CGSize = .zero
  
  private let threshold: CGFloat = 100.0
  
  public func body(content: Content) -> some View {
    content
      .offset(x: translation.width)
      .rotationEffect(.degrees(Double(translation.width / 20)))
      .gesture(
        DragGesture()
        .onChanged { value in
          translation = CGSize(width: value.translation.width, height: 0)
        }
        .onEnded { value in
          if abs(value.translation.width) > threshold {
            isActive = (false, handleSwipeDirection(value.translation.width))
          } else {
            translation = .zero
          }
        }
      )
      .animation(.interactiveSpring(), value: translation)
  }
  
  private func handleSwipeDirection(_ width: CGFloat) -> SwipeDirection {
    width > 0 ? .right : .left
  }
}
