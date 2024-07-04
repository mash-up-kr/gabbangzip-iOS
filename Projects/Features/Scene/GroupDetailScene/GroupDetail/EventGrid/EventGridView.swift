//
//  PICListView.swift
//  GroupDetail
//
//  Created by 최혜린 on 6/29/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import DesignSystem
import Models
import SwiftUI

struct EventGridView: View {
  var events: [EventItemInfo]
  
  var body: some View {
    ScrollView {
      titleView
      
      if events.isEmpty {
        emptyView
      } else {
        galleryView
      }
    }
    .padding(.horizontal, 16)
  }
  
  var titleView: some View {
    HStack {
      Text("우리들의 인생네컷")
        .foregroundStyle(DesignSystem.Colors.gray80)
        .font(.head18)
      Spacer()
    }
    .padding(.top, 16)
  }
  
  var columns = [GridItem(spacing: 33), GridItem(spacing: 33)]
  
  var galleryView: some View {
    LazyVGrid(
      columns: columns,
      spacing: 16
    ) {
        ForEach(events) { picInfo in
          EventItemView(eventInfo: picInfo)
        }
      }
    .padding(.top, 17)
  }
  
  var emptyView: some View {
    VStack(spacing: 0) {
      DesignSystem.Images.empty
        .padding(.bottom, 16)
      
      Text("그룹 이벤트를 만들고\n우리끼리 PIC으로 인생 네컷을 모아보세요.")
        .multilineTextAlignment(.center)
        .foregroundStyle(DesignSystem.Colors.gray60)
        .font(.text14)
    }
    .padding(.vertical, 40)
  }
}

#Preview {
  EventGridView(events: [])
}

#Preview {
  EventGridView(
    events: [
      EventItemInfo.mock,
      EventItemInfo.mock,
      EventItemInfo.mock,
      EventItemInfo.mock,
      EventItemInfo.mock,
      EventItemInfo.mock,
      EventItemInfo.mock
    ]
  )
}
