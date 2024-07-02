//
//  EventComponentView.swift
//  GroupDetail
//
//  Created by 최혜린 on 6/30/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import SwiftUI

import DesignSystem
import Models

import Nuke
import NukeUI

struct EventItemView: View {
  var eventInfo: EventItemInfo
  
  var body: some View {
    VStack(alignment: .leading ,spacing: 0) {
      LazyImage(
        url: eventInfo.imageURL
      ) { state in
        if let image = state.image {
          image.resizable()
            .aspectRatio(contentMode: .fit)
        }
      }
      .padding(.bottom, 8)
      
      Text(eventInfo.title)
        .font(.head18)
        .foregroundStyle(DesignSystem.Colors.gray80)
        .padding(.bottom, 4)
      
      Text(eventInfo.date)
        .font(.caption12)
        .foregroundStyle(DesignSystem.Colors.gray60)
    }
  }
}

#Preview {
  HStack(spacing: 33) {
    EventItemView(eventInfo: EventItemInfo.mock)
    EventItemView(eventInfo: EventItemInfo.mock)
  }
  .padding(.horizontal, 20)
}
