//
//  HistoryItemView.swift
//  GroupDetail
//
//  Created by 최혜린 on 6/30/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import DesignSystem
import Lovebug
import Models
import NukeUI
import SwiftUI

struct HistoryItemView: View {
  private let history: History
  private let columns = [GridItem(spacing: 12), GridItem(spacing: 12)]
  private let keyword: GroupData.Keyword
  private let s3BucketDomain: String
  private let tapAction: (History) -> Void
  
  init(
    history: History,
    keyword: GroupData.Keyword,
    s3BucketDomain: String,
    tapAction: @escaping (History) -> Void
  ) {
    self.history = history
    self.keyword = keyword
    self.s3BucketDomain = s3BucketDomain
    self.tapAction = tapAction
  }
  
  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      photoView
        .padding(.bottom, 6)
      
      Text(history.name)
        .font(.head18)
        .foregroundStyle(DesignSystem.Colors.gray80)
        .padding(.bottom, 4)
      
      Text(history.date)
        .font(.caption12)
        .foregroundStyle(DesignSystem.Colors.gray60)
    }
    .onTapGesture { tapAction(history) }
  }
  
  var photoView: some View {
    LazyVGrid(columns: columns, spacing: 12) {
      ForEach(history.images, id: \.self) { card in
        PhotoWithFrame(
          frameShape: card.frame.image,
          foregroundColor: keyword.backgroundColor,
          imageURLString: s3BucketDomain + card.imageURL
        )
      }
    }
    .padding(12)
    .background(keyword.backgroundColor)
    .cornerRadius(20)
  }
}

#Preview {
  HStack(spacing: 33) {
    HistoryItemView(
      history: .mock,
      keyword: .company,
      s3BucketDomain: ""
    ) { _ in }
  }
  .padding(.horizontal, 20)
}
