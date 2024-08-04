//
//  GroupListView.swift
//  Main
//
//  Created by YangJoonHyeok on 7/2/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import ComposableArchitecture
import DesignSystem
import Models
import NukeUI
import SwiftUI

public struct GroupListView: View {
  @Bindable var store: StoreOf<GroupListCore>
  private let columns = [
    GridItem(.flexible(), spacing: 9),
    GridItem(.flexible(), spacing: 9)
  ]

  public init(store: StoreOf<GroupListCore>) {
    self.store = store
  }

  public var body: some View {
    VStack(spacing: 0) {
      NavigationBar(
        type: .logoAndOneIcon(DesignSystem.Icons.user),
        oneIconAction: { store.send(.myPageButtonTapped) }
      )
      
      ScrollView {
        VStack {
          ForEach(Array(store.groups.enumerated()), id: \.element) { index, group in
            VStack(spacing: 16) {
              Button(
                action: { store.send(.groupHeaderButtonTapped) },
                label: {
                  HStack {
                    Text(group.name)
                      .font(.head24)
                      .foregroundStyle(Color(DesignSystem.Colors.gray80))
                      .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Spacer()
                    
                    DesignSystem.Icons.rightArrow
                      .resizable()
                      .aspectRatio(contentMode: .fit)
                      .frame(width: 26, height: 26)
                  }
                  .padding(.horizontal, 16)
                  .padding(.top, 14)
                }
              )
              
              HStack {
                createTag(from: group.keyword)
                Tag(type: .etc(.custom(group.statusDescription)))
                Spacer(minLength: 0)
              }
              .padding(.horizontal, 16)
              
              groupContentView(group: group)
              
              if store.groups.count - 1 != index {
                Divider()
                  .frame(height: 8)
                  .overlay(DesignSystem.Colors.gray20)
                  .padding(.top, 8)
              }
            }
          }
        }
      }
    }
    .background(DesignSystem.Colors.gray0)
    .onAppear { store.send(.onAppear) }
    .overlay(alignment: .bottomTrailing) {
      FloatingButton(isExpended: $store.floatingButtonExpended.sending(\.floatingButtonExpendedChanged)) {
        FloatingOptionButton(
          title: "그룹 들어가기",
          icon: DesignSystem.Icons.groupIn,
          action: { store.send(.joinGroupButtonTapped) }
        )
        
        FloatingOptionButton(
          title: "그룹 만들기",
          icon: DesignSystem.Icons.groupPlus,
          action: { store.send(.createGroupButtonTapped) }
        )
      }
      .padding(.trailing, 16)
      .padding(.bottom, 24)
    }
  }
}

extension GroupListView {
  @MainActor
  private func groupContentView(group: GroupData) -> some View {
    VStack(spacing: 16) {
      if group.status == .noCurrentEvent || group.status == .eventCompleted {
        FlipView(
          frontContent: {
            PhotoCard(status: mapStatus(from: group.keyword)) {
              photoCardFrontView(from: group)
            }
          },
          backContent: {
            PhotoCard(status: mapStatus(from: group.keyword)) {
              photoCardBackView(from: group)
            }
          }
        )
        .padding(.horizontal, 41.5)
      } else {
        PhotoCard(status: mapStatus(from: group.keyword)) {
          VStack(spacing: 16) {
            photoCardFrontView(from: group)
            
            if group.status == .noPastAndCurrentEvent {
              SmallButton(type: .active, smallButtonContentType: .generateEvent, action: {})
            }
          }
        }
        .padding(.horizontal, 41.5)
        
        if let buttonType = mapButtonType(from: group.status) {
          SmallButton(type: .active, smallButtonContentType: buttonType, action: {})
        }
      }
    }
  }
  
  @MainActor
  private func photoCardFrontView(from group: GroupData) -> some View {
    VStack(spacing: 16) {
      Text(
        group.status == .noPastAndCurrentEvent
        ? "이벤트를 만들어 보세요!"
        : group.recentEvent.date?.toGroupEventDateString() ?? ""
      )
      .font(.body16)
      .foregroundStyle(DesignSystem.Colors.gray80)
      
      photoInFrame(for: group.keyword, with: group.cardFrontImageURL)
      .padding(.horizontal, 30)
      
      Text("이벤트명입니다")
        .font(.head20)
        .foregroundStyle(DesignSystem.Colors.gray80)
    }
  }
  
  @MainActor
  private func photoCardBackView(from group: GroupData) -> some View {
    VStack(spacing: 16) {
      Text(group.recentEvent.date?.toGroupEventDateString() ?? "")
        .font(.body16)
        .foregroundStyle(DesignSystem.Colors.gray80)
      
      LazyVGrid(columns: columns, spacing: 9) {
        ForEach(group.cardBackImages ?? [], id: \.self) { card in
          photoInFrame(
            for: mapKeyword(from: card.frame),
            with: card.imageURL,
            color: mapColor(from: group.keyword)
          )
        }
      }
      .padding(.horizontal, 20)
      
      Text("이벤트명입니다")
        .font(.head20)
        .foregroundStyle(DesignSystem.Colors.gray80)
    }
  }
  
  @MainActor
  private func photoInFrame(
    for keyword: GroupData.Keyword,
    with image: String,
    color: Color? = nil
  ) -> some View {
    let resolvedColor = color ?? mapColor(from: keyword)
    let icon = mapIcon(for: keyword)
    
    return icon
      .resizable()
      .aspectRatio(contentMode: .fit)
      .foregroundStyle(resolvedColor)
      .background {
        LazyImage(url: URL(string: image)) { state in
          if let image = state.image {
            ZStack {
              DesignSystem.Colors.gray0
              
          }
        }
      }
  }
  
  private func mapStatus<T: View>(from keyword: GroupData.Keyword) -> PhotoCard<T>.Status {
    switch keyword {
    case .school:
      return .school
    case .company:
      return .company
    case .crew:
      return .crew
    case .network:
      return .network
    case .exercise:
      return .exercise
    case .hobby:
      return .hobby
    case .littleMoim:
      return .littleMoim
    }
  }
  
  private func mapKeyword(from frame: CardBackImage.Frame) -> GroupData.Keyword {
    switch frame {
    case .snowman:
      return .school
    case .plus:
      return .network
    case .ghost:
      return .company
    case .clover:
      return .littleMoim
    case .sexy:
      return .exercise
    case .flower:
      return .hobby
    case .hamburger:
      return .crew
    }
  }
  
  private func mapColor(from keyword: GroupData.Keyword) -> Color {
    switch keyword {
    case .school:
      return DesignSystem.Colors.conifer30
    case .company:
      return DesignSystem.Colors.magentaPink30
    case .crew: 
      return DesignSystem.Colors.mayaBlue30
    case .network:
      return DesignSystem.Colors.coral30
    case .exercise:
      return DesignSystem.Colors.dandelion30
    case .hobby:
      return DesignSystem.Colors.malibu30
    case .littleMoim:
      return DesignSystem.Colors.lavender30
    }
  }
  
  private func createTag(from keyword: GroupData.Keyword) -> some View {
    switch keyword {
    case .school:
      return Tag(type: .category(.school))
    case .company:
      return Tag(type: .category(.company))
    case .crew:
      return Tag(type: .category(.crew))
    case .network:
      return Tag(type: .category(.network))
    case .exercise:
      return Tag(type: .category(.exercise))
    case .hobby:
      return Tag(type: .category(.hobby))
    case .littleMoim:
      return Tag(type: .category(.littleMoim))
    }
  }
  
  private func mapIcon(for keyword: GroupData.Keyword) -> Image {
    switch keyword {
    case .school:
      return DesignSystem.Icons.snowmanFrame
    case .company:
      return DesignSystem.Icons.ghostFrame
    case .crew: 
      return DesignSystem.Icons.hamburgerFrame
    case .network:
      return DesignSystem.Icons.plusFrame
    case .exercise:
      return DesignSystem.Icons.sexyFrame
    case .hobby:
      return DesignSystem.Icons.flowerFrame
    case .littleMoim:
      return DesignSystem.Icons.cloverFrame
    }
  }
  
  private func mapButtonType(from status: GroupData.Status) -> SmallButtonContentType? {
    switch status {
    case .beforeMyUpload:
      return .uploadPIC
    case .afterMyUpload, .afterMyVote:
      return .stabbing
    case .beforeMyVote:
      return .vote
    default:
      return nil
    }
  }
}

#Preview {
  GroupListView(
    store: Store(
      initialState: .init(),
      reducer: GroupListCore.init
    )
  )
}
