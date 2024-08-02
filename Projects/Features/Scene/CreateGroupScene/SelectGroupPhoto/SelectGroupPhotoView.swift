//
//  SelectGroupPhotoView.swift
//  CreateGroup
//
//  Created by YangJoonHyeok on 7/9/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import ComposableArchitecture
import DesignSystem
import Models
import SwiftUI

public struct SelectGroupPhotoView: View {
  @Bindable private var store: StoreOf<SelectGroupPhotoCore>

  public init(store: StoreOf<SelectGroupPhotoCore>) {
    self.store = store
  }

  public var body: some View {
    VStack(spacing: 0) {
      NavigationBar(
        type: .titleWithBackButton("그룹 만들기", .center),
        backButtonAction: { store.send(.backButtonTapped) }
      )
      
      PICProgressView(progress: 0.75)
        .padding(.horizontal, 16)
      
      Text("그룹의 대표 사진을 추가해 주세요")
        .font(.head18)
        .foregroundStyle(DesignSystem.Colors.gray80)
        .padding(.horizontal, 16)
        .padding(.vertical, 32)
      
      GabbangzipPhotoPicker(
        selectedPhotosInfo: $store.selectedPhotosInfo.sending(\.selectedImagesChanged),
        isPresentedError: .constant(false),
        maxSelectedCount: .single,
        matching: .images
      ) {
        PhotoCard(status: store.keyword.convertToPhotoCardStatus()) {
          VStack(spacing: 0) {
            Tag(type: store.keyword.tagType)
            
            photoInFrame(for: store.keyword, selectedPhotosInfo: store.selectedPhotosInfo)
              .padding(.init(top: 24, leading: 30, bottom: 26, trailing: 30))
            
            Text(store.groupName)
              .font(.head20)
              .foregroundStyle(DesignSystem.Colors.gray80)
              .padding(.bottom, 12)
          }
        }
      }
      .padding(.horizontal, 42)
      
      Spacer()
      
      GabbangzipBottomButton(
        type: store.nextButtonType,
        title: "다음",
        action: { store.send(.nextButtonTapped) }
      )
      .padding(.horizontal, 16)
      .padding(.bottom, 12)
    }
  }
}

extension SelectGroupPhotoView {
  @MainActor
  private func photoInFrame(
    for keyword: GroupData.Keyword,
    selectedPhotosInfo: [PhotoInfo]
  ) -> some View {
    let galleryIcon = selectedPhotosInfo.isEmpty ? DesignSystem.Icons.galleryPlusBlack : DesignSystem.Icons.galleryWhite
    
    return keyword.frame
      .resizable()
      .aspectRatio(contentMode: .fit)
      .foregroundStyle(keyword.foregroundColor)
      .background {
        if let firstPhotoInfo = selectedPhotosInfo[safe: 0],
           let image = UIImage(data: firstPhotoInfo.data) {
          Image(uiImage: image)
            .resizable(resizingMode: .stretch)
            .overlay(Color.black.opacity(0.3))
        } else {
          keyword.backgroundColor
        }
      }
      .overlay {
        galleryIcon
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(width: 22, height: 22)
      }
  }
}

#Preview {
  SelectGroupPhotoView(
    store: Store(
      initialState: .init(groupName: "그룹명열글자입니다요", keyword: .school),
      reducer: SelectGroupPhotoCore.init
    )
  )
}
