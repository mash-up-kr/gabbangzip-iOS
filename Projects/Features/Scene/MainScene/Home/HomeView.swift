//
//  HomeView.swift
//  Main
//
//  Created by YangJoonHyeok on 7/2/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import Common
import ComposableArchitecture
import DesignSystem
import Models
import NukeUI
import SwiftUI

public struct HomeView: View {
  @Bindable var store: StoreOf<HomeCore>

  public init(store: StoreOf<HomeCore>) {
    self.store = store
  }

  public var body: some View {
    VStack(spacing: 0) {
      NavigationBar(
        type: .logoAndOneIcon(DesignSystem.Icons.user),
        oneIconAction: { store.send(.myPageButtonTapped) }
      )
      
      HStack {
        Spacer()
        
        Group {
          switch store.displayMode {
          case .list:
            Button(action: { store.send(.displayModeChanged(.grid)) }) {
              DesignSystem.Icons.grid
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 18, height: 18)
            }
          case .grid:
            Button(action: { store.send(.displayModeChanged(.list)) }) {
              DesignSystem.Icons.list
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 18, height: 18)
            }
          }
        }
        .padding(.vertical, 11)
        .padding(.trailing, 20)
      }
      .frame(height: 40)
      
      Divider()
        .frame(height: 8)
        .overlay(DesignSystem.Colors.gray20)
        .padding(.top, 12)
      
      switch store.state.displayMode {
      case .list:
        GroupListView(store: store.scope(state: \.groupList, action: \.groupList))
      case .grid:
        GroupGridView(store: store.scope(state: \.groupGrid, action: \.groupGrid))
      }
    }
    .background(DesignSystem.Colors.gray0)
    .disableSwipeBack()
    .onAppear { store.send(.onAppear) }
    .toast(
      isPresented: $store.toastPresented.sending(\.toastPresentedChanged),
      type: store.toastType
    )
    .overlay(alignment: .bottomTrailing) {
      FloatingButton(isExpanded: $store.floatingButtonExpanded.sending(\.floatingButtonExpandedChanged)) {
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
    .onTapGesture {
      store.send(.screenTapped)
    }
  }
}

#Preview {
  HomeView(
    store: Store(
      initialState: .init(),
      reducer: HomeCore.init
    )
  )
}
