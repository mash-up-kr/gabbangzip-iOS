//
//  ToastView.swift
//  DesignSystem
//
//  Created by GREEN on 6/29/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import SwiftUI

public struct ToastView: View {
  private let type: ToastType
  
  public init(type: ToastType) {
    self.type = type
  }
  
  public var body: some View {
    switch type {
    case let .onlyText(title):
      TextToastView(title: title)
    case let .textWithCheckIcon(title):
      TextWithIconToastView(
        title: title,
        image: DesignSystem.Icons.popupCheck
      )
    case let .textWithInfoIcon(title):
      TextWithIconToastView(
        title: title,
        image: DesignSystem.Icons.popupInfo
      )
    case let .textWithIcon(title, image):
      TextWithIconToastView(
        title: title,
        image: image
      )
    }
  }
}

// MARK: - 텍스트 토스트
private struct TextToastView: View {
  private let title: String
  
  fileprivate init(title: String) {
    self.title = title
  }
  
  fileprivate var body: some View {
    Text(title)
      .font(.body16)
      .foregroundStyle(DesignSystem.Colors.gray0)
      .padding(.vertical, 16)
      .padding(.horizontal, 24)
      .background(DesignSystem.Colors.gray100.opacity(0.5))
      .cornerRadius(30)
  }
}

// MARK: - 텍스트 + 아이콘 토스트
private struct TextWithIconToastView: View {
  private let title: String
  private let image: Image
  
  fileprivate init(
    title: String,
    image: Image
  ) {
    self.title = title
    self.image = image
  }
  
  fileprivate var body: some View {
    HStack(spacing: 16) {
      image
        .resizable()
        .frame(width: 20, height: 20)
      
      Text(title)
        .font(.body16)
        .foregroundStyle(DesignSystem.Colors.gray0)
    }
    .padding(.vertical, 16)
    .padding(.horizontal, 24)
    .background(DesignSystem.Colors.gray100.opacity(0.5))
    .cornerRadius(30)
  }
}

#Preview {
  VStack {
    ToastView(type: .onlyText("그룹원들을 쿡 찔렀어요!"))
    
    ToastView(type: .textWithCheckIcon("링크를 복사했어요."))
    
    ToastView(type: .textWithInfoIcon("로그인에 실패했어요."))
    
    ToastView(type: .textWithIcon("하이", DesignSystem.Icons.popupInfo))
  }
}
