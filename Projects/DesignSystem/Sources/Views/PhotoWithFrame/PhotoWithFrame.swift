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
  
  public init(keyword: GroupData.Keyword, imageURLString: String) {
    self.keyword = keyword
    self.imageURLString = imageURLString
  }
  
  public var body: some View {
    keyword.frame
      .resizable()
      .aspectRatio(contentMode: .fit)
      .foregroundStyle(keyword.foregroundColor)
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
  PhotoWithFrame(
    keyword: .company,
    imageURLString: "https://pic-api-bucket.s3.ap-northeast-2.amazonaws.com/pic/9c8f3f24-6ed2-4a2e-8af5-52aeff93b230.jpeg"
  )
}
