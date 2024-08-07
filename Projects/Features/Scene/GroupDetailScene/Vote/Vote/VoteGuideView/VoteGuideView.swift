//
//  VoteGuideView.swift
//  GroupDetail
//
//  Created by hyerin on 8/6/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import DesignSystem
import SwiftUI

struct VoteGuideView: View {
  var guideTypes: [GuideType]
  var swipeAction: () -> Void
  
  var body: some View {
    ZStack {
      ForEach(0..<guideTypes.count, id: \.self) { index in
        if let type = guideTypes[safe: index] {
          GuideView(guideType: type)
            .opacity(index == 0 ? 1 : 0)
        }
      }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(DesignSystem.Colors.gray100.opacity(0.4))
    .gesture(
      DragGesture(minimumDistance: 0, coordinateSpace: .local)
      .onEnded({ value in
        if value.translation.width < 0 {
          swipeAction()
        }
      })
    )
  }
}

public struct GuideView: View, Equatable {
  var id = UUID()
  let guideType: GuideType
  
  public var body: some View {
    VStack(spacing: 0) {
      Text(guideType.description)
        .font(.head16)
        .foregroundStyle(DesignSystem.Colors.gray0)
        .padding(.bottom, 13)
        .multilineTextAlignment(.center)
      
      guideType.image
    }
  }
}

public enum GuideType {
  case vote
  case pass
  
  enum SwipeDirection {
    case left
    case right
  }
  
  var description: String {
    switch self {
    case .vote:
      return "오른쪽으로 스와이프해서\n사진을 PIC 해보세요"
    case .pass:
      return "맘에 들지 않는 사진은\n왼쪽으로 스와이프 해보세요"
    }
  }
  
  var image: Image {
    switch self {
    case .vote:
      return DesignSystem.Images.voteGuideRight
    case .pass:
      return DesignSystem.Images.voteGuideLeft
    }
  }
  
  var swipeDirection: SwipeDirection {
    switch self {
    case .vote:
      return .right
    case .pass:
      return .left
    }
  }
}

#Preview {
  VoteGuideView(
    guideTypes: [.vote, .pass],
    swipeAction: {
      ()
    }
  )
}
