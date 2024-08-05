//
//  PhotoWithFrame.swift
//  Common
//
//  Created by hyerin on 8/5/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import Models
import NukeUI
import SwiftUI

public struct PhotoWithFrame: View {
  public let keyword: GroupData.Keyword
  public let imageURLString: String
  public let isBackgroundClear: Bool
  
  public init(
    keyword: GroupData.Keyword,
    imageURLString: String,
    isBackgroundClear: Bool
  ) {
    self.keyword = keyword
    self.imageURLString = imageURLString
    self.isBackgroundClear = isBackgroundClear
  }
  
  public var body: some View {
    keyword.frame
      .resizable()
      .aspectRatio(contentMode: .fit)
      .foregroundStyle(isBackgroundClear ? .white : keyword.backgroundColor)
      .background {
        LazyImage(url: URL(string: imageURLString)) { state in
          if let image = state.image {
            ZStack {
              DesignSystem.Colors.gray0
              
              image.resizable()
                .scaledToFit()
            }
          } else {
            keyword.backgroundColor
          }
        }
      }
  }
}

#Preview {
  Group {
    PhotoWithFrame(
      keyword: .company,
      imageURLString: "https://24ai.tech/ru/wp-content/uploads/sites/4/2023/10/01_product_1_sdelat-kvadratnym-scaled.jpg",
      isBackgroundClear: false
    )
    
    PhotoWithFrame(
      keyword: .company,
      imageURLString: "https://24ai.tech/ru/wp-content/uploads/sites/4/2023/10/01_product_1_sdelat-kvadratnym-scaled.jpg",
      isBackgroundClear: true
    )
  }
}
