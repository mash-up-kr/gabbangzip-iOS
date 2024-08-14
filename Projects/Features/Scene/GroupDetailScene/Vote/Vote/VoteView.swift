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
import Models
import SwiftUI

public struct VoteView: View {
  @Bindable private var store: StoreOf<VoteCore>
  
  public init(store: StoreOf<VoteCore>) {
    self.store = store
  }
  
  public var body: some View {
    ZStack {
      VStack(spacing: 0) {
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

        TitleView(name: store.userInfo.nickname)
        
        Spacer()
        
        VoteSwipeView(
          voteOptions: store.voteOptions,
          voteOptionCount: store.imageCount,
          swipeDirection: store.swipeDirection,
          swipeAction: { index, swipeDirection in
            store.send(.cardSwiped(index, swipeDirection))
          }
        )
        
        Spacer()
        
        VoteButtonView(store: store)
        
        Spacer()
      }
      
      if store.isNeedGuideView && !store.guideTypes.isEmpty {
        VoteGuideView(
          guideTypes: store.guideTypes,
          swipeAction: {
            store.send(.guideViewSwiped)
          }
        )
        .transition(.opacity.animation(.easeInOut))
        .animation(.easeInOut, value: store.guideTypes)
      }
    }
    .onAppear {
      store.send(.onAppear)
    }
    .background(DesignSystem.Images.gradientBackground)
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
    .toast(
      isPresented: $store.isToastPresented.sending(\.setToastPresented),
      type: .onlyText(store.toastType.message),
      time: 1.0
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
        .foregroundStyle(DesignSystem.Colors.gray80)
    }
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
        voteButtonState: VoteButtonState.defaultState,
        passsButtonState: VoteButtonState.defaultState,
        eventID: 0,
        voteOptions: [],
        pickedImageIDs: [],
        swipeDirection: SwipeDirection.defaultState,
        isPopupPresented: false,
        isToastPresented: false,
        popupType: .close,
        toastType: .error,
        isFirstVoteDone: false,
        isNeedGuideView: true,
        isVoteButtonDisabled: false,
        guideTypes: [GuideType.vote, GuideType.pass]
      ),
      reducer: VoteCore.init
    )
  )
}
