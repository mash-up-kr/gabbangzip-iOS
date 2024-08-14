//
//  CustomBottomSheetView.swift
//  GroupDetail
//
//  Created by hyerin on 8/14/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import SwiftUI

struct CustomBottomSheetView<Content: View>: View {
  @State private var offsetY: CGFloat = 0
  @State private var fullHeight: CGFloat = 0
  @State private var isExpanded: Bool = false
    
  private let minHeight: CGFloat
  private let maxHeight: CGFloat
  private let content: Content
  
  init(
    minHeight: CGFloat,
    maxHeight: CGFloat,
    @ViewBuilder content: () -> Content
  ) {
    self.minHeight = minHeight
    self.maxHeight = maxHeight
    self.content = content()
  }
  
  var body: some View {
    GeometryReader { geometry in
      VStack {
        Capsule()
          .frame(width: 40, height: 6)
          .padding(.top, 8)
          .padding(.bottom, 12)
        
        content
      }
      .frame(width: geometry.size.width, height: max(minHeight, maxHeight + offsetY))
      .background(.white)
      .cornerRadius(16, corners: [.topLeft, .topRight])
      .offset(y: isExpanded ? 0 : geometry.size.height - minHeight + 24)
      .animation(.easeInOut, value: isExpanded)
      .gesture(
        DragGesture()
          .onChanged { value in
            self.offsetY = value.translation.height
          }
          .onEnded { value in
            if value.translation.height < -100 {
                self.isExpanded = true
            } else if value.translation.height > 100 {
                self.isExpanded = false
            }
            self.offsetY = 0
          }
      )
      .onAppear {
        self.fullHeight = geometry.size.height
      }
    }
  }
}
