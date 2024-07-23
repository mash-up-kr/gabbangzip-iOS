//
//  VoteView.swift
//  GroupDetail
//
//  Created by hyerin on 7/18/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

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
              store.send(.closeButtonTapped)
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
        
        VStack(spacing: 4) {
          DesignSystem.Icons.voteBlack
          
          Text("\(store.name)의 PIC")
            .font(.head18)
        }
        .padding(.bottom, 46)
        
        ZStack {
          RoundedRectangle(cornerRadius: 10)
            .frame(width: 330, height: 440)
            .cornerRadius(10)
            .foregroundStyle(.clear)
          
          VoteSwipeView(
            imageURLs: $store.imageURLs,
            swipeDirection: $store.swipeDirection,
            swipeAction: { index, swipeDirection in
              store.send(.cardSwiped(index, swipeDirection))
            }
          )
        }
        .padding(.bottom, 68)
        
        HStack(spacing: 16) {
          VoteButton(
            type: .pass,
            state: $store.passsButtonState,
            action: {
              store.send(.passButtonTapped)
            }
          )
          
          VoteButton(
            type: .vote,
            state: $store.voteButtonState,
            action: {
              store.send(.voteButtonTapped)
            }
          )
        }
      }
    }
    .popup(
      isPresented: $store.isClosePopupPresented,
      title: "나가실건가요?",
      description: "페이지를 나가면\n처음부터 다시 투표 하게돼요.",
      leftButtonTitle: "나가기",
      leftButtonAction: {
        store.send(.exitButtonTapped)
      },
      rightButtonTitle: "계속 투표하기",
      rightButtonAction: {
        store.send(.continueButtonTapped)
      }
    )
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
        swipeDirection: .defaultState,
        showClosePopup: false
      ),
      reducer: VoteCore.init
    )
  )
}
