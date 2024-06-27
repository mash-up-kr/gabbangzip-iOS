//
//  ToastView.swift
//  Main
//
//  Created by Hyun A Song on 6/24/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import ComposableArchitecture
import DesignSystem
import SwiftUI

public struct ToastView: View {
  public let message: String
  
  public init(message: String) {
    self.message = message
  }
  
  public var body: some View {
    HStack {
      DesignSystem.Icons.loginIcon
        .resizable()
        .frame(
          width: 20,
          height: 20
        )
        .padding(.leading)
      Text(message)
        .font(.body16)
        .foregroundColor(.white)
        .padding(.trailing)
    }
    .padding()
    .background(DesignSystem.Colors.gray60)
    .cornerRadius(40)
  }
}
