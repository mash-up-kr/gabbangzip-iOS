//
//  CreateEventProcessView.swift
//  CreateEvent
//
//  Created by Hyun A Song on 8/8/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import ComposableArchitecture
import DesignSystem
import Models
import NukeUI
import SwiftUI

public struct CreateEventProcessView: View {
  @Bindable var store: StoreOf<CreateEventProcessCore>
  
  public init(store: StoreOf<CreateEventProcessCore>) {
    self.store = store
  }
  
  public var body: some View {
    VStack(spacing: 0) {
      NavigationBar(
        type: .titleWithBackButton(CreateEventProcessViewNameSpace.navigationTitle, .center),
        backButtonAction: { store.send(.backButtonTapped) }
      )
      
      VStack(spacing: 0) {
        HStack(spacing: 0) {
          Text(CreateEventProcessViewNameSpace.eventTitle)
            .font(.head18)
            .foregroundStyle(DesignSystem.Colors.gray80)
          
          Spacer()
        }
        
        GabbangzipInput(
          text: $store.text.sending(\.textChanged),
          placeholderText: CreateEventProcessViewNameSpace.eventTitlePlaceHolder,
          maxLength: 10
        )
        .padding(.top, 16)
        
        HStack(spacing: 0) {
          Text(CreateEventProcessViewNameSpace.eventDate)
            .font(.head18)
            .foregroundStyle(DesignSystem.Colors.gray80)
          
          Spacer()
        }
        .padding(.top, 24)
        
        GabbangzipDate(date: store.currentDate)
        .padding(.top, 16)
        
        HStack(spacing: 0) {
          Text(CreateEventProcessViewNameSpace.eventPicture)
            .font(.head18)
            .foregroundStyle(DesignSystem.Colors.gray80)
          
          Spacer()
        }
        .padding(.top, 24)
        
        // 사진
        
        Spacer()
        
        Text(CreateEventProcessViewNameSpace.notice)
          .font(.text14)
          .foregroundStyle(DesignSystem.Colors.gray60)
        
        GabbangzipBottomButton(
          type: store.completeButtonType,
          title: CreateEventProcessViewNameSpace.complete,
          action: { store.send(.completeButtonTapped) }
        )
        .padding(.top, 16)
      }
      .padding(.all, 16)
    }
    .onAppear { store.send(.onAppear) }
    .popup(
      isPresented: $store.isExiting,
      title: CreateEventProcessViewNameSpace.popupTitle,
      description: CreateEventProcessViewNameSpace.popupDescription,
      leftButtonTitle: CreateEventProcessViewNameSpace.popupLeftButtonTitle,
      leftButtonAction: { store.send(.popupLeftButtonTapped) },
      rightButtonTitle: CreateEventProcessViewNameSpace.popupRightButtonTitle,
      rightButtonAction: { store.send(.popupRightButtonTapped) }
    )
  }
}

// MARK: - CreateEventProcessViewNameSpace
extension CreateEventProcessView {
  fileprivate enum CreateEventProcessViewNameSpace {
    static let navigationTitle = "이벤트 만들기"
    static let eventTitle = "이벤트 한줄 요약"
    static let eventTitlePlaceHolder = "이벤트를 한줄로 요약해주세요."
    static let eventDate = "날짜"
    static let eventDatePlaceHolder = "YY/MM/DD"
    static let eventPicture = "사진 선택"
    static let popupTitle = "나가실건가요?"
    static let popupDescription = "페이지를 나가면\n작성중인 내용이 삭제돼요"
    static let popupLeftButtonTitle = "나가기"
    static let popupRightButtonTitle = "계속 작성하기"
    static let notice = "이벤트 PIC은 2시간 후에 종료돼요."
    static let complete = "완료"
  }
}

#Preview {
  CreateEventProcessView(
    store: Store(
      initialState: CreateEventProcessCore.State(),
      reducer: CreateEventProcessCore.init
    )
  )
}
