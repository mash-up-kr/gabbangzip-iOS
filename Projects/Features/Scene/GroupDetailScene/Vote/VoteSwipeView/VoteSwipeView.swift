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
  @Binding var swipeDirection: SwipeDirection
  
  @State private var offset = CGSize.zero
  @State private var angle: Double = 0
  
  var swipeAction: (Int, SwipeDirection) -> Void

  var body: some View {
    ZStack {
      ForEach(0..<imageURLs.count, id: \.self) { index in
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
              x: index == imageURLs.count - 1 ? offset.width : 0,
              y: index == imageURLs.count - 1 ? offset.height : 0
            )
            .rotationEffect(.degrees(index == imageURLs.count - 1 ? angle : 0))
            .animation(.easeInOut(duration: 0.3), value: offset)
            .animation(.easeInOut(duration: 0.3), value: angle)
        }
      }
    }
    .onChange(of: swipeDirection, { oldValue, direction in
      swipeCard(to: direction)
    })
  }

  private func swipeCard(to direction: SwipeDirection) {
    if direction == .defaultState {
      return
    } else {
      let width = direction == .left ? -300 : 300
      let rotation = direction == .left ? -15.0 : 15.0

      withAnimation(.easeInOut(duration: 0.2)) {
        self.offset = CGSize(width: width, height: 0)
        self.angle = rotation
      } completion: {
        self.offset = CGSize(width: 0, height: 0)
        self.angle = 0
        self.swipeAction(imageURLs.count - 1, direction)
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
    swipeDirection: .constant(.defaultState),
    swipeAction: { _, _  in }
  )
}

