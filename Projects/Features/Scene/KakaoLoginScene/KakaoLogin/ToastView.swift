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

struct ToastView: View {
  let message: String
  
  var body: some View {
    HStack {
      Image(uiImage: DesignSystem.Icons.Login.loginIconUIImage)
        .resizable()
        .frame(width: 20, height: 20)
        .padding(.leading)
      Text(message)
        .foregroundColor(.white)
        .padding(.trailing)
    }
    .padding()
    .background(DesignSystem.Colors.gray60)
    .cornerRadius(40)
  }
}
