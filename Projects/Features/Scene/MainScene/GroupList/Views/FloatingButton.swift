//
//  FloatingButton.swift
//  Main
//
//  Created by YangJoonHyeok on 8/4/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import DesignSystem
import Models
import SwiftUI

struct FloatingButton<Content>: View where Content: View {
  @Binding private var isExpanded: Bool
  private var floatingOptionButtons: () -> Content
  
  init(
    isExpanded: Binding<Bool>,
    @ViewBuilder floatingOptionButtons: @escaping () -> Content
  ) {
    self._isExpanded = isExpanded
    self.floatingOptionButtons = floatingOptionButtons
  }
  
  var body: some View {
    VStack(alignment: .trailing) {
      VStack(spacing: 16) {
        floatingOptionButtons()
      }
      .frame(width: 168, height: isExpanded ? nil : 0, alignment: .bottom)
      .padding(.all, 16)
      .background(DesignSystem.Colors.gray0)
      .cornerRadius(16)
      .opacity(isExpanded ? 1 : 0)
      
      Button(
        action: {
          withAnimation {
            isExpanded.toggle()
          }
        },
        label: {
          DesignSystem.Icons.plusTemplate
            .resizable()
            .scaledToFit()
            .padding(.all, 16)
            .frame(width: 54, height: 54)
            .foregroundStyle(isExpanded ? DesignSystem.Colors.gray100 : DesignSystem.Colors.gray0)
            .background(isExpanded ? DesignSystem.Colors.gray0 : DesignSystem.Colors.gray80)
            .clipShape(Circle())
            .rotationEffect(.degrees(isExpanded ? 45 : 0))
        }
      )
    }
  }
}
#Preview {
  FloatingButton(isExpanded: .constant(true)) {
    FloatingOptionButton(title: "그룹 들어가기", icon: DesignSystem.Icons.groupIn, action: {})
    FloatingOptionButton(title: "그룹 만들기", icon: DesignSystem.Icons.groupPlus, action: {})
  }
  .background(.gray)
}
