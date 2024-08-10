//
//  PhotoWithFrame.swift
//  Lovebug
//
//  Created by YangJoonHyeok on 8/8/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import Models
import NukeUI
import SwiftUI

public struct PhotoWithFrame: View {
  public let frameShape: Image
  public let foregroundColor: Color
  public let imageURLString: String

  public init(
    frameShape: Image,
    foregroundColor: Color,
    imageURLString: String
  ) {
    self.frameShape = frameShape
    self.foregroundColor = foregroundColor
    self.imageURLString = imageURLString
  }

  public var body: some View {
    frameShape
      .resizable()
      .aspectRatio(contentMode: .fit)
      .foregroundStyle(foregroundColor)
      .background {
        LazyImage(url: URL(string: imageURLString)) { state in
          if let image = state.image {
            image
              .resizable()
              .aspectRatio(contentMode: .fill)
          }
        }
      }
      .clipped()
  }
}

#Preview {
  Group {
    PhotoWithFrame(
      frameShape: GroupData.Keyword.company.frame,
      foregroundColor: GroupData.Keyword.company.foregroundColor,
      imageURLString: "https://24ai.tech/ru/wp-content/uploads/sites/4/2023/10/01_product_1_sdelat-kvadratnym-scaled.jpg"
    )

    PhotoWithFrame(
      frameShape: GroupData.Keyword.company.frame,
      foregroundColor: GroupData.Keyword.company.foregroundColor,
      imageURLString: "https://24ai.tech/ru/wp-content/uploads/sites/4/2023/10/01_product_1_sdelat-kvadratnym-scaled.jpg"
    )
  }
}
