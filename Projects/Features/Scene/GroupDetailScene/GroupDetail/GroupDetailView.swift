//
//  GroupDetailView.swift
//  GroupDetail
//
//  Created by 최혜린 on 6/29/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import ComposableArchitecture
import DesignSystem
import Models
import SwiftUI

public struct GroupDetailView: View {
  @State private var showSheet = true
  @State private var bottomSheetHeight: CGFloat = 0
  private let store: StoreOf<GroupDetailCore>

  public init(store: StoreOf<GroupDetailCore>) {
    self.store = store
  }

  public var body: some View {
    ScrollView {
      VStack(spacing: 0) {
        NavigationBar(
          type: .titleWithBackButtonAndIcon(store.groupDetail.groupName, DesignSystem.Icons.group),
          backButtonAction: {
            store.send(.backButtonTapped)
          },
          rightIconAction: {
            store.send(.memberListButtonTapped)
          }
        )
        
        EventContainerView(eventDetail: store.groupDetail.eventDetail) { state in
          store.send(.eventContainerViewButtonTapped(state))
        }
        
        dividerView
      }
      .overlay(ViewGeometry())
      .onPreferenceChange(ViewHeightKey.self) { height in
        self.bottomSheetHeight = height
      }
    }
    .scrollIndicators(.hidden)
    .sheet(isPresented: $showSheet) {
      EventGridView(events: store.groupDetail.eventItems)
        .scrollIndicators(.hidden)
        .presentationDetents([.height(bottomSheetHeight), .large])
        .interactiveDismissDisabled()
        .presentationDragIndicator(.hidden)
        .presentationBackgroundInteraction(.enabled(upThrough: .large))
     }
  }
  
  private var dividerView: some View {
    Rectangle()
      .foregroundStyle(DesignSystem.Colors.gray20)
      .frame(height: 10)
  }
}

struct ViewHeightKey: PreferenceKey {
  static var defaultValue: CGFloat = .zero
  static func reduce(
    value: inout CGFloat,
    nextValue: () -> CGFloat
  ) {
    value = nextValue()
  }
}

struct ViewGeometry: View {
  var body: some View {
    GeometryReader { geometry in
      Color.clear
        .preference(
          key: ViewHeightKey.self,
          // TODO: UIScreen 사용하지 않는 방향으로 개선 예정
          value: UIScreen.main.bounds.height - geometry.size.height - UIScreen.topSafeArea - UIScreen.bottomSafeArea
        )
    }
  }
}

// TODO: UIScreen 사용하지 않는 방향으로 개선 예정
extension UIScreen {
    static var topSafeArea: CGFloat {
        let keyWindow = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?.windows
            .filter({$0.isKeyWindow}).first
        
        return (keyWindow?.safeAreaInsets.top) ?? 0
    }
  
  static var bottomSafeArea: CGFloat {
      let keyWindow = UIApplication.shared.connectedScenes
          .filter({$0.activationState == .foregroundActive})
          .map({$0 as? UIWindowScene})
          .compactMap({$0})
          .first?.windows
          .filter({$0.isKeyWindow}).first
      
      return (keyWindow?.safeAreaInsets.bottom) ?? 0
  }
}

// 이벤트 목록 빈 경우
#Preview {
  GroupDetailView(
    store: Store(
      initialState: .init(groupDetail: GroupDetail.emptyMock),
      reducer: {
        GroupDetailCore()
      }
    )
  )
}

// 이벤트 목록 있는 경우
#Preview {
  GroupDetailView(
    store: Store(
      initialState: .init(groupDetail: GroupDetail.mock),
      reducer: {
        GroupDetailCore()
      }
    )
  )
}
