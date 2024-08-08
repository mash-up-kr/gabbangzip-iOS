//
//  GroupView.swift
//  Main
//
//  Created by YangJoonHyeok on 8/8/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import ComposableArchitecture
import DesignSystem
import Models
import NukeUI
import SwiftUI
import Lovebug

public struct GroupView: View {
  @Bindable var store: StoreOf<GroupCore>
  private let columns = [
    GridItem(.flexible(), spacing: 9),
    GridItem(.flexible(), spacing: 9)
  ]
  
  public init(store: StoreOf<GroupCore>) {
    self.store = store
  }
  
  public var body: some View {
    VStack(spacing: 16) {
      if store.status == .noPastAndCurrentEvent || store.status == .noCurrentEvent {
        GroupHeaderView(title: "이벤트를 만들어 보세요!", isButtonStyle: false)
      } else {
        Button(
          action: { store.send(.headerButtonTapped) },
          label: { GroupHeaderView(title: store.name, isButtonStyle: true) }
        )
      }

      HStack {
        Tag(type: store.keyword.tagType)
        Tag(type: .etc(.custom(store.statusDescription)))
        Spacer(minLength: 0)
      }
      .padding(.horizontal, 16)
      
      groupContentView()
      
      if !store.isLast {
        Divider()
          .frame(height: 8)
          .overlay(DesignSystem.Colors.gray20)
          .padding(.top, 8)
      }
    }
  }
}

extension GroupView {
  @MainActor
  private func groupContentView() -> some View {
    VStack(spacing: 16) {
      if store.status == .noCurrentEvent || store.status == .eventCompleted {
        FlipView(
          frontContent: {
            PhotoCard(status: store.keyword.convertToPhotoCardStatus()) {
              photoCardFrontView()
            }
          },
          backContent: {
            PhotoCard(status: store.keyword.convertToPhotoCardStatus()) {
              photoCardBackView()
            }
          }
        )
        .padding(.horizontal, 41.5)
      } else {
        PhotoCard(status: store.keyword.convertToPhotoCardStatus()) {
          VStack(spacing: 16) {
            photoCardFrontView()
            
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
            GabbangzipPhotoPicker(
              selectedPhotosInfo: $store.selectedPhotosInfo.sending(\.selectedPhotosInfo),
              maxSelectedCount: .custom(4),
              matching: .images,
              content: {
                SmallButton(
                  type: .active,
                  smallButtonContentType: buttonType,
                  action: {}
                )
                .disabled(true)
              }
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
  
  @MainActor
  private func photoCardFrontView() -> some View {
    VStack(spacing: 16) {
      Text(
        store.status == .noPastAndCurrentEvent
        ? "이벤트를 만들어 보세요!"
        : store.recentEvent.date?.toGroupEventDateString() ?? ""
      )
      .font(.body16)
      .foregroundStyle(DesignSystem.Colors.gray80)
      
      PhotoWithFrame(
        keyword: store.keyword,
        foregroundColor: store.keyword.foregroundColor,
        imageURLString: store.s3BucketDomain + store.cardFrontImageURL
      )
      .padding(.horizontal, 30)
      
      Text(store.recentEvent.name ?? "")
        .font(.head20)
        .foregroundStyle(DesignSystem.Colors.gray80)
    }
  }
  
  @MainActor
  private func photoCardBackView() -> some View {
    VStack(spacing: 16) {
      Text(store.recentEvent.date?.toGroupEventDateString() ?? "")
        .font(.body16)
        .foregroundStyle(DesignSystem.Colors.gray80)
      
      LazyVGrid(columns: columns, spacing: 9) {
        ForEach(store.cardBackImages ?? [], id: \.self) { card in
          PhotoWithFrame(
            keyword: store.keyword,
            foregroundColor: store.keyword.foregroundColor,
            imageURLString: store.s3BucketDomain + store.cardFrontImageURL
          )
        }
      }
      .padding(.horizontal, 20)
      
      Text(store.recentEvent.name ?? "")
        .font(.head20)
        .foregroundStyle(DesignSystem.Colors.gray80)
    }
  }
}

#Preview {
  GroupView(
    store: Store(
      initialState: .init(
        userInfo: Shared<UserInfo>.init(UserInfo(
          userID: 1,
          nickname: "james",
          accessToken: "",
          refreshToken: ""
        )),
        id: 0,
        name: "test",
        keyword: GroupData.Keyword.company,
        status: GroupData.Status.eventCompleted,
        statusDescription: "hi",
        recentEvent: RecentEvent(
          id: 0, 
          name: "hi",
          date: "2024-07-05T00:00:00Z"
        ),
        cardFrontImageURL: "",
        cardBackImages: nil,
        isLast: false
      ),
      reducer: GroupCore.init
    )
  )
}
