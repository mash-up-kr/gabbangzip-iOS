//
//  ShareButton.swift
//  GroupDetail
//
//  Created by 최혜린 on 6/29/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import DesignSystem
import SwiftUI

struct ShareButton: View {
  private var action: () -> Void
  
  init(action: @escaping () -> Void = {}) {
    self.action = action
  }
  
  var body: some View {
    Image(uiImage: DesignSystem.Icons.shareUIImage)
      .frame(width: 48, height: 48)
      .background(DesignSystem.Colors.gray80)
      .cornerRadius(14)
  }
}

#Preview {
  ShareButton()
}
