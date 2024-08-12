//
//  GroupHeaderView.swift
//  Main
//
//  Created by YangJoonHyeok on 8/8/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import DesignSystem
import SwiftUI

struct GroupHeaderView: View {
  var title: String
  var isButtonStyle: Bool
  
  init(title: String, isButtonStyle: Bool) {
    self.title = title
    self.isButtonStyle = isButtonStyle
  }
  
  var body: some View {
    HStack {
      Text(title)
        .font(.head24)
        .foregroundStyle(Color(DesignSystem.Colors.gray80))
        .frame(maxWidth: .infinity, alignment: .leading)
      
      Spacer()
      
      if isButtonStyle {
        DesignSystem.Icons.rightArrow
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(width: 26, height: 26)
      }
    }
    .padding(.horizontal, 16)
    .padding(.top, 14)
  }
}

#Preview {
  GroupHeaderView(title: "이벤트를 만들어 보세요!", isButtonStyle: false)
}
