//
//  DisableSwipeBackModifier.swift
//  Common
//
//  Created by YangJoonHyeok on 8/15/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import SwiftUI

public struct DisableSwipeBackModifier: ViewModifier {
  @State private var userInteractionDisabled: Bool
  
  public init(userInteractionDisabled: Bool = false) {
    self.userInteractionDisabled = userInteractionDisabled
  }
  
  public func body(content: Content) -> some View {
    content
      .simultaneousGesture(
        DragGesture()
          .onChanged { value in
            let isLeftToRightSwipe = value.translation.width > 0
            if isLeftToRightSwipe {
              userInteractionDisabled = true
            }
          }
          .onEnded { value in
            userInteractionDisabled = false
          }
      )
      .overlay {
        if userInteractionDisabled {
          Color.clear
        }
      }
  }
}
