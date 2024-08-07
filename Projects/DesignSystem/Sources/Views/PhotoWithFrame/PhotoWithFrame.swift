//
//  PhotoWithFrame.swift
//  Common
//
//  Created by hyerin on 8/5/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import NukeUI
import SwiftUI

public struct PhotoWithFrame: View {
  public let frame: Image
  public let backgroundColor: Color
  public let imageURLString: String
  public let isBackgroundClear: Bool
  
  public init(
    frame: Image,
    backgroundColor: Color,
    imageURLString: String,
    isBackgroundClear: Bool
  ) {
    self.frame = frame
    self.backgroundColor = backgroundColor
    self.imageURLString = imageURLString
    self.isBackgroundClear = isBackgroundClear
  }
  
  public var body: some View {
    frame
      .resizable()
      .aspectRatio(contentMode: .fit)
      .foregroundStyle(isBackgroundClear ? .white : backgroundColor)
      .background {
        LazyImage(url: URL(string: imageURLString)) { state in
          if let image = state.image {
            ZStack {
              DesignSystem.Colors.gray0
              
              image.resizable()
                .scaledToFit()
            }
          } else {
            backgroundColor
          }
        }
      }
  }
}

#Preview {
  Group {
    PhotoWithFrame(
      frame: DesignSystem.Icons.ghostFrame,
      backgroundColor: DesignSystem.Colors.magentaPink20,
      imageURLString: "https://24ai.tech/ru/wp-content/uploads/sites/4/2023/10/01_product_1_sdelat-kvadratnym-scaled.jpg",
      isBackgroundClear: false
    )
    
    PhotoWithFrame(
      frame: DesignSystem.Icons.ghostFrame,
      backgroundColor: DesignSystem.Colors.magentaPink20,
      imageURLString: "https://24ai.tech/ru/wp-content/uploads/sites/4/2023/10/01_product_1_sdelat-kvadratnym-scaled.jpg",
      isBackgroundClear: true
    )
  }
}
