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
  private let groupDetail: GroupDetailInfo
  private var action: () -> Void
  @Bindable var store: StoreOf<GroupDetailCore>
  
  init(
    groupDetail: GroupDetailInfo,
    action: @escaping () -> Void,
    store: StoreOf<GroupDetailCore>
  ) {
    self.groupDetail = groupDetail
    self.action = action
    self.store = store
  }
  
  var body: some View {
    VStack(spacing: 0) {
      Text(groupDetail.recentEventDetail.date)
        .foregroundStyle(DesignSystem.Colors.gray80)
        .font(.body16)
        .padding(.bottom, 8)
      
      Text(groupDetail.name)
        .foregroundStyle(DesignSystem.Colors.gray80)
        .font(.head20)
        .padding(.bottom, 8)
      
      Text("\(groupDetail.recentEventDetail.deadline) PIC 종료")
        .font(.text14)
        .foregroundStyle(DesignSystem.Colors.gray80)
        .padding(.bottom, 16)
      
      PhotoWithFrame(
        frameShape: groupDetail.keyword.frame,
        foregroundColor: DesignSystem.Colors.gray20,
        imageURLString: groupDetail.cardFrontImageURL
      )
      .padding(.horizontal, 76)
      
      Text(groupDetail.statusDescription)
        .font(.caption12)
        .foregroundStyle(DesignSystem.Colors.gray60)
        .padding(.init(top: 24, leading: 0, bottom: 8, trailing: 0))
      
      if groupDetail.status == .beforeMyUpload {
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
