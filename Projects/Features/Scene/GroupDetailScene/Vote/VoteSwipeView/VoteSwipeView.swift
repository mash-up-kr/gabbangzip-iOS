//
//  VoteSwipeView.swift
//  Main
//
//  Created by hyerin on 7/20/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import Common
import ComposableArchitecture
import NukeUI
import SwiftUI

struct VoteSwipeView: View {
  @Binding var imageURLs: [URL?]
  var swipeAction: (Int, SwipeDirection) -> Void
   
  var body: some View {
    ZStack {
      ForEach(0..<imageURLs.count, id: \.self) { index in
        CardView(imageURL: self.imageURLs[index])
         .draggable(
          isActive: Binding(
            get: { (self.imageURLs.indices.contains(index), .left) },
            set: { isActive, swipeDirection in
              if !isActive {
                swipeAction(index, swipeDirection)
              }
            }
          )
         )
       }
     }
   }
}

struct CardView: View {
  var imageURL: URL?
  
  var body: some View {
    LazyImage(url: imageURL) { state in
      if let image = state.image {
        image.resizable()
          .scaledToFill()
          .frame(width: 330, height: 440)
          .clipped()
          .cornerRadius(10)
      }
    }
    .shadow(
      color: .black.opacity(0.12),
      radius: 12,
      x: 4,
      y: 4
    )
  }
}

#Preview {
  VoteSwipeView(
    imageURLs: .constant(
      [
        URL(string: "https://t1.daumcdn.net/cafeattach/1YVY7/391cac378245e0d2c7bba59d6efc7692baf88aa6"),
        URL(string: "https://i.namu.wiki/i/hq6niPhkN8EhXuIkCNx32AN614AxXcaxKQ1EnyFaHN41caJM7rPfkfppaGZNlpgmXWPbkD_MGTbmGE4_BOrIBg.webp")
      ]
    ),
    swipeAction: { _, _  in }
  )
}

