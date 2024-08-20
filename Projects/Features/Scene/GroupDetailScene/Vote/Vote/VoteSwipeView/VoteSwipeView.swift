//
//  VoteSwipeView.swift
//  Main
//
//  Created by hyerin on 7/20/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import Common
import ComposableArchitecture
import Models
import NukeUI
import SwiftUI

struct VoteSwipeView: View {
  var voteOptions: [Option]
  var voteOptionCount: Int
  var swipeDirection: SwipeDirection
  
  @State private var offset = CGSize.zero
  @State private var angle: Double = 0
  
  var swipeAction: (Int, SwipeDirection) -> Void

  var body: some View {
    ZStack {
      clearCardView
      
      ForEach(0..<voteOptionCount, id: \.self) { index in
        if let imageURL = voteOptions[safe: index] {
          CardView(imageURL: URL(string: imageURL.imageURL))
            .draggable(isActive: Binding(
              get: { (self.voteOptions.indices.contains(index), .left) },
              set: { isActive, swipeDirection in
                if !isActive {
                  swipeAction(index, self.swipeDirection)
                }
              })
            )
            .offset(
              x: index == voteOptionCount - 1 ? offset.width : 0,
              y: index == voteOptionCount - 1 ? offset.height : 0
            )
            .rotationEffect(.degrees(index == voteOptionCount - 1 ? angle : 0))
        }
      }
    }
    .onChange(of: swipeDirection, { oldValue, direction in
      swipeCard(to: direction)
    })
  }
  
  private var clearCardView: some View {
    RoundedRectangle(cornerRadius: 10)
      .frame(width: 330, height: 440)
      .cornerRadius(10)
      .foregroundStyle(.clear)
  }

  private func swipeCard(to direction: SwipeDirection) {
    if direction != .defaultState {
      let width = direction == .left ? -600 : 600
      let rotation = direction == .left ? -20.0 : 20.0

      withAnimation(.easeInOut(duration: 0.3)) {
        self.offset = CGSize(width: width, height: 0)
        self.angle = rotation
      } completion: {
        self.offset = CGSize(width: 0, height: 0)
        self.angle = 0
        self.swipeAction(voteOptionCount - 1, direction)
      }
    }
  }
}

private struct CardView: View {
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
    voteOptions: [],
    voteOptionCount: 2,
    swipeDirection: .defaultState,
    swipeAction: { _, _ in}
  )
}
