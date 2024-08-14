//
//  EventProgressView.swift
//  GroupDetail
//
//  Created by 최혜린 on 6/29/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import ComposableArchitecture
import DesignSystem
import Lovebug
import Models
import NukeUI
import SwiftUI

struct EventProgressView: View {
  private var action: () -> Void
  @Bindable var store: StoreOf<GroupDetailCore>
  
  init(
    action: @escaping () -> Void,
    store: StoreOf<GroupDetailCore>
  ) {
    self.action = action
    self.store = store
  }
  
  var body: some View {
    VStack(spacing: 0) {
      Text(store.recentEventDateString)
        .foregroundStyle(DesignSystem.Colors.gray80)
        .font(.body16)
        .padding(.bottom, 8)
      
      Text(store.recentEventName)
        .foregroundStyle(DesignSystem.Colors.gray80)
        .font(.head20)
        .padding(.bottom, 8)
      
      Text("\(store.recentEventDeadLineString) PIC 종료")
        .font(.text14)
        .foregroundStyle(DesignSystem.Colors.gray80)
        .padding(.bottom, 16)
      
      PhotoWithFrame(
        frameShape: store.frame,
        foregroundColor: DesignSystem.Colors.gray20,
        imageURLString: store.cardFrontImageURLString
      )
      .padding(.horizontal, 76)
      
      Text(store.statusMessage)
        .font(.caption12)
        .foregroundStyle(DesignSystem.Colors.gray60)
        .padding(.init(top: 24, leading: 0, bottom: 8, trailing: 0))
      
      if store.groupDetail?.status == .beforeMyUpload {
        GabbangzipPhotoPicker(
          selectedPhotosInfo: $store.selectedPhotosInfo,
          isPresentedError: .constant(false),
          maxSelectedCount: .custom(4)) {
            SmallButton(
              type: .active,
              smallButtonContentType: .uploadPIC
            ) {
              action()
            }
            .disabled(true)
          }
      } else {
        SmallButton(
          type: .active,
          smallButtonContentType: store.smallButtonType
        ) {
          action()
        }
      }
    }
    .padding(.init(top: 16, leading: 0, bottom: 34, trailing: 0))
  }
}
