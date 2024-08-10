//
//  PhotoCardBackView.swift
//  Main
//
//  Created by YangJoonHyeok on 8/11/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import DesignSystem
import Lovebug
import Models
import SwiftUI

struct PhotoCardBackView: View {
  var recentEventData: String
  var cardBackImages: [CardBackImage]
  var recentEventName: String
  var foregroundColor: Color
  var s3BucketDomain: String
  
  private let columns = [
    GridItem(.flexible(), spacing: 9),
    GridItem(.flexible(), spacing: 9)
  ]
  
  init(
    recentEventData: String,
    cardBackImages: [CardBackImage],
    recentEventName: String,
    foregroundColor: Color,
    s3BucketDomain: String
  ) {
    self.recentEventData = recentEventData
    self.cardBackImages = cardBackImages
    self.recentEventName = recentEventName
    self.foregroundColor = foregroundColor
    self.s3BucketDomain = s3BucketDomain
  }
  
  var body: some View {
    VStack(spacing: 16) {
      Text(recentEventData)
        .font(.body16)
        .foregroundStyle(DesignSystem.Colors.gray80)
      
      LazyVGrid(columns: columns, spacing: 9) {
        ForEach(cardBackImages, id: \.self) { card in
          PhotoWithFrame(
            frameShape: card.frame.image,
            foregroundColor: foregroundColor,
            imageURLString: s3BucketDomain + card.imageURL
          )
        }
      }
      .padding(.horizontal, 20)
      
      Text(recentEventName)
        .font(.head20)
        .foregroundStyle(DesignSystem.Colors.gray80)
    }
  }
}

#Preview {
  PhotoCardBackView(
    recentEventData: "2024-07-05T00:00:00Z",
    cardBackImages: [],
    recentEventName: "우리의 믿음",
    foregroundColor: DesignSystem.Colors.conifer30,
    s3BucketDomain: ""
  )
}
