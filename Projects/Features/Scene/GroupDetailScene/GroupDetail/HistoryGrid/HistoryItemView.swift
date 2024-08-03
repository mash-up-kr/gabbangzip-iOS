//
//  HistoryItemView.swift
//  GroupDetail
//
//  Created by 최혜린 on 6/30/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import DesignSystem
import Models
import NukeUI
import SwiftUI

struct HistoryItemView: View {
  private let history: History
  
  init(history: History) {
    self.history = history
  }
  
  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      LazyImage(url: URL(string: history.images.first!.imageURL)) { state in
        if let image = state.image {
          image.resizable()
            .aspectRatio(contentMode: .fit)
        }
      }
      .padding(.bottom, 8)
      
      Text(history.name)
        .font(.head18)
        .foregroundStyle(DesignSystem.Colors.gray80)
        .padding(.bottom, 4)
      
      Text(history.date)
        .font(.caption12)
        .foregroundStyle(DesignSystem.Colors.gray60)
    }
  }
}

#Preview {
  HStack(spacing: 33) {
    HistoryItemView(history: .mock)
  }
  .padding(.horizontal, 20)
}
