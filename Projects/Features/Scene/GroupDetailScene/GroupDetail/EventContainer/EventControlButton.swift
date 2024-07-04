//
//  EventControlButton.swift
//  GroupDetail
//
//  Created by 최혜린 on 7/5/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import DesignSystem
import SwiftUI

struct EventControlButton: View {
  private let buttonType: SmallButtonContentType?
  private let action: () -> Void
  
  init(buttonType: SmallButtonContentType?, action: @escaping () -> Void) {
    self.buttonType = buttonType
    self.action = action
  }
  
  var body: some View {
    if let smallButtonContentType = buttonType {
      SmallButton(
        type: .constant(.active),
        smallButtonContentType: smallButtonContentType
      ) {
        action()
      }
    } else {
      ShareButton {
        action()
      }
    }
  }
}
