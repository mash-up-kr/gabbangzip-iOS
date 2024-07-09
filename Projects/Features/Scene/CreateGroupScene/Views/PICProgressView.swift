//
//  PICProgressView.swift
//  CreateGroup
//
//  Created by YangJoonHyeok on 7/9/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import DesignSystem
import SwiftUI

struct PICProgressView: View {
  @State private var progressBarSize: CGSize = .zero
  private var progress: Double
  
  init(progress: Double) {
    self.progress = progress
  }
  
  var body: some View {
    RoundedRectangle(cornerRadius: 16)
      .frame(height: 4)
      .foregroundStyle(DesignSystem.Colors.gray20)
      .overlay(
        GeometryReader { proxy in
          Color.clear
            .preference(
              key: ProgressBarSizePreferenceKey.self,
              value: proxy.size
            )
        }
      )
      .onPreferenceChange(ProgressBarSizePreferenceKey.self) { size in
        progressBarSize = size
      }
      .overlay {
        HStack {
          RoundedRectangle(cornerRadius: 16)
            .foregroundStyle(DesignSystem.Colors.gray80)
            .frame(width: progressBarSize.width * progress)
          
          Spacer(minLength: 0)
        }
      }
  }
}

fileprivate struct ProgressBarSizePreferenceKey: PreferenceKey {
  static var defaultValue: CGSize = .zero
  static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
    value = nextValue()
  }
}

#Preview {
  PICProgressView(progress: 0.1)
}
