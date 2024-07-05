//
//  FlipView.swift
//  Main
//
//  Created by YangJoonHyeok on 7/2/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import SwiftUI

struct FlipView<Front: View, Back: View>: View {
  @State private var isFlipped = false
  @State private var rotationAngle: Double = 0
  @State private var frontDegree: Double = 0
  @State private var backDegree: Double = -90.0
  private var frontContent: Front
  private var backContent: Back
  
  init(
    frontContent: () -> Front,
    backContent: () -> Back
  ) {
    self.frontContent = frontContent()
    self.backContent = backContent()
  }
  
  var body: some View {
    ZStack {
      backContent
        .rotation3DEffect(.degrees(backDegree), axis: (x: 0, y: 1, z: 0))
      
      frontContent
        .rotation3DEffect(.degrees(frontDegree), axis: (x: 0, y: 1, z: 0))
    }
    .onTapGesture {
      flipCard()
    }
  }
  
  private func flipCard() {
    isFlipped.toggle()
    
    if isFlipped {
      withAnimation(.linear(duration: 0.2)) {
        frontDegree = 90
      }
      withAnimation(.linear(duration: 0.2).delay(0.2)) {
        backDegree = 0
      }
    } else {
      withAnimation(.linear(duration: 0.2)) {
        backDegree = -90
      }
      withAnimation(.linear(duration: 0.2).delay(0.2)) {
        frontDegree = 0
      }
    }
  }
}

#Preview {
  FlipView(
    frontContent: {
      RoundedRectangle(cornerRadius: 16)
        .frame(width: 200, height: 300)
        .foregroundStyle(Color.blue)
    },
    backContent: {
      RoundedRectangle(cornerRadius: 16)
        .frame(width: 200, height: 300)
        .foregroundStyle(Color.red)
    }
  )
}
