//
//  BlurView.swift
//  DesignSystem
//
//  Created by YangJoonHyeok on 7/7/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import SwiftUI

public struct BlurView: UIViewRepresentable {
  private var style: UIBlurEffect.Style
  
  public init(style: UIBlurEffect.Style) {
    self.style = style
  }
  
  public func makeUIView(context: Context) -> UIVisualEffectView {
    return UIVisualEffectView(effect: UIBlurEffect(style: style))
  }
  
  public func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
    uiView.effect = UIBlurEffect(style: style)
  }
}
