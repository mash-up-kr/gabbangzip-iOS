//
//  VoteView.swift
//  GroupDetail
//
//  Created by hyerin on 7/18/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import Common
import ComposableArchitecture
import DesignSystem
import SwiftUI

public struct VoteView: View {
  @Bindable private var store: StoreOf<VoteCore>
  
  public init(store: StoreOf<VoteCore>) {
    self.store = store
  }
  
  public var body: some View {
    ZStack {
      DesignSystem.Images.gradientBackground
      
      VStack {
        HStack {
          Spacer()
          
          Button(
            action: {
              store.send(.exitButtonTapped)
            }, label: {
              DesignSystem.Icons.close
            }
          )
          .padding(.trailing, 16)
          .padding(.top, 27)
        }
        
        Spacer()
      }

      VStack(spacing: 0) {
        
        TitleView(name: store.name)
        
        VoteSwipeView(
          imageURLs: store.imageURLs,
          imageCount: store.imageCount,
          swipeDirection: store.swipeDirection,
          swipeAction: { index, swipeDirection in
            store.send(.cardSwiped(index, swipeDirection))
          }
        )
        .padding(.bottom, 68)
        
        VoteButtonView(store: store)
      }
    }
    .popup(
      isPresented: $store.isPopupPresented,
      title: store.popupType.title,
      description: store.popupType.description,
      leftButtonTitle: store.popupType.leftButtonTitle,
      leftButtonAction: {
        store.send(.popupLeftButtonTapped)
      },
      rightButtonTitle: store.popupType.rightButtonTitle,
      rightButtonAction: {
        store.send(.popupRightButtonTapped)
      }
    )
  }
}

private struct TitleView: View {
  let name: String
  
  var body: some View {
    VStack(spacing: 4) {
      DesignSystem.Icons.voteBlack
      
      Text("\(name)의 PIC")
        .font(.head18)
    }
    .padding(.bottom, 46)
  }
}

private struct VoteButtonView: View {
  let store: StoreOf<VoteCore>
  
  var body: some View {
    HStack(spacing: 16) {
      VoteButton(
        type: .pass,
        state: store.passButtonState,
        action: {
          store.send(.passButtonTapped)
        }
      )
      .disabled(store.isVoteButtonDisabled)
      
      VoteButton(
        type: .vote,
        state: store.voteButtonState,
        action: {
          store.send(.voteButtonTapped)
        }
      )
      .disabled(store.isVoteButtonDisabled)
    }
  }
}

#Preview {
  VoteView(
    store: Store(
      initialState: .init(
        name: "혜린",
        voteButtonState: VoteButtonState.defaultState,
        passsButtonState: VoteButtonState.defaultState,
        imageURLs: [
          URL(string: "https://t1.daumcdn.net/cafeattach/1YVY7/391cac378245e0d2c7bba59d6efc7692baf88aa6"),
          URL(string: "https://i.namu.wiki/i/hq6niPhkN8EhXuIkCNx32AN614AxXcaxKQ1EnyFaHN41caJM7rPfkfppaGZNlpgmXWPbkD_MGTbmGE4_BOrIBg.webp")
        ],
        pickedImageIndex: [],
        swipeDirection: SwipeDirection.defaultState,
        isPopupPresented: false,
        popupType: .close,
        isVoteButtonDisabled: false
      ),
      reducer: VoteCore.init
    )
  )
}
