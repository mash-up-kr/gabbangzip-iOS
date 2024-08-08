//
//  FloatingOptionButton.swift
//  Main
//
//  Created by YangJoonHyeok on 8/4/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import DesignSystem
import SwiftUI

struct FloatingOptionButton: View {
  private var title: String
  private var icon: Image
  private var action: () -> Void
  
  init(title: String, icon: Image, action: @escaping () -> Void) {
    self.title = title
    self.icon = icon
    self.action = action
  }
  
  var body: some View {
    Button(
      action: action,
      label: {
        HStack {
          icon
            .resizable()
            .scaledToFit()
            .frame(width: 26, height: 26)
            .foregroundStyle(DesignSystem.Colors.gray80)
          
          Text(title)
            .font(.body16)
            .foregroundStyle(DesignSystem.Colors.gray80)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
      }
    )
  }
}


#Preview {
  FloatingOptionButton(title: "그룹 들어가기", icon: DesignSystem.Icons.groupIn, action: {})
}
