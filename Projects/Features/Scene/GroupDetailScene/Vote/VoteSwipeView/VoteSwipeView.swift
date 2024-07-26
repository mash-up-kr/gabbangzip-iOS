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
  var imageURLs: [URL?]
  var imageCount: Int
  var swipeDirection: SwipeDirection
  
  @State private var offset = CGSize.zero
  @State private var angle: Double = 0
  
  var swipeAction: (Int, SwipeDirection) -> Void

  var body: some View {
    ZStack {
      ForEach(0..<imageCount, id: \.self) { index in
        if let imageURL = imageURLs[safe: index] {
          CardView(imageURL: imageURL)
            .draggable(isActive: Binding(
              get: { (self.imageURLs.indices.contains(index), .left) },
              set: { isActive, swipeDirection in
                if !isActive {
                  swipeAction(index, self.swipeDirection)
                }
              })
            )
            .offset(
              x: index == imageCount - 1 ? offset.width : 0,
              y: index == imageCount - 1 ? offset.height : 0
            )
            .rotationEffect(.degrees(index == imageCount - 1 ? angle : 0))
        }
      }
    }
    .onChange(of: swipeDirection, { oldValue, direction in
      swipeCard(to: direction)
    })
  }

  private func swipeCard(to direction: SwipeDirection) {
    if direction != .defaultState {
      let width = direction == .left ? -500 : 500
      let rotation = direction == .left ? -20.0 : 20.0

      withAnimation(.easeInOut(duration: 0.2)) {
        self.offset = CGSize(width: width, height: 0)
        self.angle = rotation
      } completion: {
        self.offset = CGSize(width: 0, height: 0)
        self.angle = 0
        self.swipeAction(imageCount - 1, direction)
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
    imageURLs: [
        URL(string: "https://t1.daumcdn.net/cafeattach/1YVY7/391cac378245e0d2c7bba59d6efc7692baf88aa6"),
        URL(string: "https://i.namu.wiki/i/hq6niPhkN8EhXuIkCNx32AN614AxXcaxKQ1EnyFaHN41caJM7rPfkfppaGZNlpgmXWPbkD_MGTbmGE4_BOrIBg.webp")
    ],
    imageCount: 2,
    swipeDirection: .defaultState,
    swipeAction: { _, _  in }
  )
}

