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
  public let keyword: GroupData.Keyword
  public let foregroundColor: Color
  public let imageURLString: String

  public init(
    keyword: GroupData.Keyword,
    foregroundColor: Color,
    imageURLString: String
  ) {
    self.keyword = keyword
    self.foregroundColor = foregroundColor
    self.imageURLString = imageURLString
  }

  public var body: some View {
    keyword.frame
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
      keyword: .company, 
      foregroundColor: GroupData.Keyword.company.foregroundColor,
      imageURLString: "https://24ai.tech/ru/wp-content/uploads/sites/4/2023/10/01_product_1_sdelat-kvadratnym-scaled.jpg"
    )

    PhotoWithFrame(
      keyword: .company,
      foregroundColor: GroupData.Keyword.company.foregroundColor,
      imageURLString: "https://24ai.tech/ru/wp-content/uploads/sites/4/2023/10/01_product_1_sdelat-kvadratnym-scaled.jpg"
    )
  }
}
