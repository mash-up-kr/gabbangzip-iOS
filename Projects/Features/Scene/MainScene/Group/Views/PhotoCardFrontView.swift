//
//  PhotoCardFrontView.swift
//  Main
//
//  Created by YangJoonHyeok on 8/11/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import DesignSystem
import Lovebug
import Models
import SwiftUI

struct PhotoCardFrontView: View {
  var title: String
  var keyword: GroupData.Keyword
  var imageURLString: String
  var recentEventName: String
  
  init(
    title: String,
    keyword: GroupData.Keyword,
    imageURLString: String,
    recentEventName: String
  ) {
    self.title = title
    self.keyword = keyword
    self.imageURLString = imageURLString
    self.recentEventName = recentEventName
  }
  
  var body: some View {
    VStack(spacing: 16) {
      Text(title)
      .font(.body16)
      .foregroundStyle(DesignSystem.Colors.gray80)
      .padding(.bottom, 6)
      
      PhotoWithFrame(
        frameShape: keyword.frame,
        foregroundColor: keyword.foregroundColor,
        imageURLString: imageURLString
      )
      .padding(.horizontal, 30)
      
      Text(recentEventName)
        .font(.head20)
        .foregroundStyle(DesignSystem.Colors.gray80)
    }
  }
}
#Preview {
  PhotoCardFrontView(
    title: "2023년 8월 11일",
    keyword: .company,
    imageURLString: "",
    recentEventName: "축하해"
  )
}
