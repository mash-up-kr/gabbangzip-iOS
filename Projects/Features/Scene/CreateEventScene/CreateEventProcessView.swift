//
//  CreateEventView.swift
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

public struct CreateEventView: View {
  @Bindable var store: StoreOf<CreateEventCore>
  
  public init(store: StoreOf<CreateEventCore>) {
    self.store = store
  }
  
  public var body: some View {
    VStack(spacing: 0) {
      VStack(spacing: 0) {
        NavigationBar(
          type: .titleWithBackButton(CreateEventViewNameSpace.navigationTitle, .center),
          backButtonAction: { store.send(.backButtonTapped) }
        )
        
        VStack(spacing: 0) {
          HStack(spacing: 0) {
            Text(CreateEventViewNameSpace.eventTitle)
              .font(.head18)
              .foregroundStyle(DesignSystem.Colors.gray80)
            
            Spacer()
          }
          .padding(.top, 16)
          
          GabbangzipInput(
            text: $store.text.sending(\.textChanged),
            placeholderText: CreateEventViewNameSpace.eventTitlePlaceHolder,
            maxLength: 10
          )
          .padding(.top, 16)
          
          HStack(spacing: 0) {
            Text(CreateEventViewNameSpace.eventDate)
              .font(.head18)
              .foregroundStyle(DesignSystem.Colors.gray80)
            
            Spacer()
          }
          .padding(.top, 24)
          
          GabbangzipDate(date: store.recentEventDate)
            .padding(.top, 16)
          
          HStack(spacing: 0) {
            Text(CreateEventViewNameSpace.eventPicture)
              .font(.head18)
              .foregroundStyle(DesignSystem.Colors.gray80)
            
            Spacer()
          }
          .padding(.top, 24)
          .padding(.bottom, 8)
        }
        .padding(.horizontal, 16)
        
        VStack(spacing: 0) {
          if !$store.selectedPhotosInfo.isEmpty {
            ScrollView(.horizontal) {
              HStack(spacing: 0) {
                GabbangzipPhotoPicker(
                  selectedPhotosInfo: $store.selectedPhotosInfo.sending(\.selectedImagesChanged),
                  maxSelectedCount: .custom(4),
                  matching: .images
                ) { SelectPhoto(selectedPhotosInfo: store.selectedPhotosInfo, maxCount: 4) }
                
                ForEach(Array($store.selectedPhotosInfo.enumerated()), id: \.offset) { index, $photoInfo in
                  if let image = UIImage(data: photoInfo.data) {
                    ZStack(
                      alignment: .topTrailing,
                      content: {
                        Image(uiImage: image)
                          .resizable()
                          .scaledToFill()
                          .frame(width: 100, height: 100)
                          .cornerRadius(10)
                          .clipped()
                          .padding(.top, 8)
                        
                        Button(
                          action: { store.send(.deleteSelectedPhoto(index)) },
                          label: {
                            DesignSystem.Icons.delete
                              .resizable()
                              .frame(width: 26, height: 26)
                          }
                        )
                        .padding(.trailing, -8)
                      }
                    )
                    .padding(.leading, 8)
                  }
                }
              }
            }
          } else {
            HStack(spacing: 0) {
              GabbangzipPhotoPicker(
                selectedPhotosInfo: $store.selectedPhotosInfo.sending(\.selectedImagesChanged),
                maxSelectedCount: .custom(4),
                matching: .images
              ) { SelectPhoto(selectedPhotosInfo: store.selectedPhotosInfo, maxCount: 4) }
              
              Spacer()
            }
          }
          
          Spacer()
          
          Text(CreateEventViewNameSpace.notice)
            .font(.text14)
            .foregroundStyle(DesignSystem.Colors.gray60)
            .padding(.bottom, 16)
          
          GabbangzipBottomButton(
            type: store.completeButtonType,
            title: CreateEventViewNameSpace.complete,
            action: { store.send(.completeButtonTapped) }
          )
          .padding(.horizontal, 16)
        }
      }
    }
    .popup(
      isPresented: $store.isExiting,
      title: CreateEventViewNameSpace.popupTitle,
      description: CreateEventViewNameSpace.popupDescription,
      leftButtonTitle: CreateEventViewNameSpace.popupLeftButtonTitle,
      leftButtonAction: { store.send(.popupLeftButtonTapped) },
      rightButtonTitle: CreateEventViewNameSpace.popupRightButtonTitle,
      rightButtonAction: { store.send(.popupRightButtonTapped) }
    )
  }
}

// MARK: - CreateEventViewNameSpace
extension CreateEventView {
  fileprivate enum CreateEventViewNameSpace {
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
  CreateEventView(
    store: Store(
      initialState: CreateEventCore.State(recentEvent: .init(id: 0, name: "가빵", date: "")),
      reducer: CreateEventCore.init
    )
  )
}
