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
  @Binding private var isExpended: Bool
  private var floatingOptionButtons: () -> Content
  
  init(
    isExpended: Binding<Bool>,
    @ViewBuilder floatingOptionButtons: @escaping () -> Content
  ) {
    self._isExpended = isExpended
    self.floatingOptionButtons = floatingOptionButtons
  }
  
  var body: some View {
    VStack(alignment: .trailing) {
      VStack(spacing: 16) {
        floatingOptionButtons()
      }
      .frame(width: 168, height: isExpended ? nil : 0, alignment: .bottom)
      .padding(.all, 16)
      .background(DesignSystem.Colors.gray0)
      .cornerRadius(16)
      .opacity(isExpended ? 1 : 0)
      
      Button(
        action: {
          withAnimation {
            isExpended.toggle()
          }
        },
        label: {
          DesignSystem.Icons.plusTemplate
            .resizable()
            .scaledToFit()
            .padding(.all, 16)
            .frame(width: 54, height: 54)
            .foregroundStyle(isExpended ? DesignSystem.Colors.gray100 : DesignSystem.Colors.gray0)
            .background(isExpended ? DesignSystem.Colors.gray0 : DesignSystem.Colors.gray80)
            .clipShape(Circle())
            .rotationEffect(.degrees(isExpended ? 45 : 0))
        }
      )
    }
  }
}
#Preview {
  FloatingButton(isExpended: .constant(true)) {
    FloatingOptionButton(title: "그룹 들어가기", icon: DesignSystem.Icons.groupIn, action: {})
    FloatingOptionButton(title: "그룹 만들기", icon: DesignSystem.Icons.groupPlus, action: {})
  }
  .background(.gray)
}
