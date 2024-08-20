//
//  GroupContentView.swift
//  Main
//
//  Created by YangJoonHyeok on 8/11/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import ComposableArchitecture
import DesignSystem
import Lovebug
import SwiftUI

struct GroupContentView: View {
  @Bindable var store: StoreOf<GroupCore>
  
  init(store: StoreOf<GroupCore>) {
    self.store = store
  }
  
  var body: some View {
    VStack(spacing: 16) {
      if store.hasCompletedEvent {
        FlipView(
          frontContent: {
            PhotoCard(status: store.keyword.convertToPhotoCardStatus()) {
              PhotoCardFrontView(
                title: store.frontTitle,
                keyword: store.keyword,
                imageURLString: store.s3BucketDomain + store.cardFrontImageURL,
                recentEventName: store.recentEventName
              )
            }
          },
          backContent: {
            PhotoCard(status: store.keyword.convertToPhotoCardStatus()) {
              PhotoCardBackView(
                recentEventDate: store.recentEventDate,
                cardBackImages: store.cardBackImages ?? [],
                recentEventName: store.recentEventName,
                foregroundColor: store.keyword.foregroundColor,
                s3BucketDomain: store.s3BucketDomain
              )
            }
          }
        )
        .padding(.horizontal, 41.5)
      } else {
        PhotoCard(status: store.keyword.convertToPhotoCardStatus()) {
          VStack(spacing: 16) {
            PhotoCardFrontView(
              title: store.frontTitle,
              keyword: store.keyword,
              imageURLString: store.s3BucketDomain + store.cardFrontImageURL,
              recentEventName: store.recentEventName
            )
            
            if store.status == .noPastAndCurrentEvent {
              SmallButton(
                type: .active,
                smallButtonContentType: .generateEvent,
                action: { store.send(.createEventButtonTapped) }
              )
            }
          }
        }
        .padding(.horizontal, 41.5)
        
        if let buttonType = store.status.smallButtonContentType {
          switch store.status {
          case .beforeMyUpload:
            SmallButton(
              type: store.stabbingButtonType,
              smallButtonContentType: buttonType,
              action: { store.send(.galleryButtonTapped) }
            )
          case .afterMyUpload, .afterMyVote:
            SmallButton(
              type: store.stabbingButtonType,
              smallButtonContentType: buttonType,
              action: { store.send(.stabbingButtonTapped) }
            )
          case .beforeMyVote:
            SmallButton(
              type: .active,
              smallButtonContentType: buttonType,
              action: { store.send(.selectPICButtonTapped) }
            )
          default:
            EmptyView()
          }
        }
      }
    }
  }
}
