//
//  Frame+extensions.swift
//  Lovebug
//
//  Created by YangJoonHyeok on 8/11/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import DesignSystem
import Models
import SwiftUI

public extension CardBackImage.Frame {
  var image: Image {
    switch self {
    case .snowman:
      return DesignSystem.Icons.snowmanFrame
    case .ghost:
      return DesignSystem.Icons.ghostFrame
    case .hamburger:
      return DesignSystem.Icons.hamburgerFrame
    case .plus:
      return DesignSystem.Icons.plusFrame
    case .sexy:
      return DesignSystem.Icons.sexyFrame
    case .flower:
      return DesignSystem.Icons.flowerFrame
    case .clover:
      return DesignSystem.Icons.cloverFrame
    }
  }
}
