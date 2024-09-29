//
//  PhotoWithFrame.swift
//  Lovebug
//
//  Created by YangJoonHyeok on 8/8/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import DesignSystem
import Models
import NukeUI
import SwiftUI

public struct PhotoWithFrame: View {
  public let frameShape: Image
  public let foregroundColor: Color
  public let imageURLString: String
  @State private var loadedImage: Image?
  public let imageLoadedCompletion: (Image, Image) -> Void

  public init(
    frameShape: Image,
    foregroundColor: Color,
    imageURLString: String,
    imageLoadedCompletion: @escaping (Image, Image) -> Void = { _, _ in}
  ) {
    self.frameShape = frameShape
    self.foregroundColor = foregroundColor
    self.imageURLString = imageURLString
    self.imageLoadedCompletion = imageLoadedCompletion
  }

  public var body: some View {
    frameShape
      .resizable()
      .aspectRatio(contentMode: .fit)
      .foregroundStyle(foregroundColor)
      .background {
        if let loadedImage {
          loadedImage
            .resizable()
            .aspectRatio(contentMode: .fill)
        } else {
          LazyImage(url: URL(string: imageURLString)) { state in
            if let image = state.image {
              DispatchQueue.main.async {
                loadedImage = image
              }
            }
            return Color.white
          }
        }
      }
      .clipped()
      .onChange(of: loadedImage ?? DesignSystem.Images.empty) { oldValue, newValue in
        imageLoadedCompletion(newValue, frameShape)
      }
  }
}

public struct PhotoWithFrameForCapture: View {
  public let frameShape: Image
  public let foregroundColor: Color
  public let image: Image

  public init(
    frameShape: Image,
    foregroundColor: Color,
    image: Image
  ) {
    self.frameShape = frameShape
    self.foregroundColor = foregroundColor
    self.image = image
  }

  public var body: some View {
    frameShape
      .resizable()
      .aspectRatio(contentMode: .fit)
      .foregroundStyle(foregroundColor)
      .background {
        image
          .resizable()
          .aspectRatio(contentMode: .fill)
      }
      .clipped()
  }
}

#Preview {
  Group {
    PhotoWithFrame(
      frameShape: GroupData.Keyword.company.frame,
      foregroundColor: GroupData.Keyword.company.foregroundColor,
      imageURLString: "https://24ai.tech/ru/wp-content/uploads/sites/4/2023/10/01_product_1_sdelat-kvadratnym-scaled.jpg",
      imageLoadedCompletion: { _, _ in }
    )
  }
}
