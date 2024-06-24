//
//  SmallButton.swift
//  DesignSystem
//
//  Created by GREEN on 6/25/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import SwiftUI

// MARK: - 기본 스몰 버튼
public struct SmallButton: View {
  @Binding private var type: SmallButtonType
  private var smallButtonContentType: SmallButtonContentType
  private var action: () -> Void
  private var isEnabled: Bool {
    type != .inactive
  }
  
  public init(
    type: Binding<SmallButtonType> = .constant(.active),
    smallButtonContentType: SmallButtonContentType,
    action: @escaping () -> Void = {}
  ) {
    self._type = type
    self.smallButtonContentType = smallButtonContentType
    self.action = action
  }
  
  public var body: some View {
    Button(
      action: {
        action()
      },
      label: {
        if smallButtonContentType.withIcon {
          SmallButtonWithIconView(
            type: $type,
            smallButtonContentType: smallButtonContentType
          )
        } else {
          SmallButtonWithoutIconView(
            type: $type,
            smallButtonContentType: smallButtonContentType
          )
        }
      }
    )
    .disabled(!isEnabled)
  }
}

// MARK: - 아이콘 포함 컨텐츠 뷰
private struct SmallButtonWithIconView: View {
  @Binding private var type: SmallButtonType
  private var smallButtonContentType: SmallButtonContentType
  
  fileprivate init(
    type: Binding<SmallButtonType>,
    smallButtonContentType: SmallButtonContentType
  ) {
    self._type = type
    self.smallButtonContentType = smallButtonContentType
  }
  
  fileprivate var body: some View {
    HStack(spacing: 10) {
      if smallButtonContentType == .copyLink {
        smallButtonContentType.icon?
          .renderingMode(.template)
          .resizable()
          .foregroundStyle(type.titleColor)
          .frame(width: 20, height: 20)
      } else {
        smallButtonContentType.icon?
          .resizable()
          .frame(width: 24, height: 24)
      }
      
      Text(smallButtonContentType.title)
        .font(.body16)
        .foregroundStyle(type.titleColor)
    }
    .padding(.horizontal, 30)
    .frame(height: 48)
    .background(type.backgroundColor)
    .cornerRadius(14)
  }
}

// MARK: - 아이콘 미포함 컨텐츠 뷰
private struct SmallButtonWithoutIconView: View {
  @Binding private var type: SmallButtonType
  private var smallButtonContentType: SmallButtonContentType
  
  fileprivate init(
    type: Binding<SmallButtonType>,
    smallButtonContentType: SmallButtonContentType
  ) {
    self._type = type
    self.smallButtonContentType = smallButtonContentType
  }
  
  fileprivate var body: some View {
    Text(smallButtonContentType.title)
      .font(.body16)
      .foregroundStyle(type.titleColor)
      .padding(.horizontal, 26)
      .frame(height: 48)
      .background(type.backgroundColor)
      .cornerRadius(14)
  }
}

// MARK: - DS에 따른 기본 스몰 버튼 타입 종류
public enum SmallButtonType {
  case active
  case inactive
  case secondary
  
  var titleColor: Color {
    switch self {
    case .active, .inactive:
      return DesignSystem.Colors.gray0
    case .secondary:
      return DesignSystem.Colors.gray80
    }
  }
  
  var backgroundColor: Color {
    switch self {
    case .active:
      return DesignSystem.Colors.gray80
    case .inactive:
      return DesignSystem.Colors.gray60
    case .secondary:
      return DesignSystem.Colors.gray40
    }
  }
}

// MARK: - 스몰 버튼 컨텐츠 타입 종류
public enum SmallButtonContentType {
  // 사진 바꾸기
  case changePicture
  // 내 PIC 올리기
  case uploadPIC
  // 갤러리
  case gallery
  // 사진 삭제
  case deletePicture
  // 링크 복사
  case copyLink
  // 프레임 바꾸기
  case changeFrame
  // 쿡 찌르기
  case stabbing
  // 이벤트 생성하기
  case generateEvent
  // 투표하기
  case vote
  
  // 아이콘 포함 여부
  var withIcon: Bool {
    switch self {
    case .changePicture, .uploadPIC, .gallery, .copyLink:
      return true
    default:
      return false
    }
  }
  
  // 타이틀
  var title: String {
    switch self {
    case .changePicture:
      "사진 바꾸기"
    case .uploadPIC:
      "내 PIC 올리기"
    case .gallery:
      "갤러리"
    case .deletePicture:
      "사진 삭제"
    case .copyLink:
      "링크 복사"
    case .changeFrame:
      "프레임 바꾸기"
    case .stabbing:
      "쿡 찌르기"
    case .generateEvent:
      "이벤트 생성하기"
    case .vote:
      "투표하기"
    }
  }
  
  // 아이콘
  var icon: Image? {
    switch self {
    case .changePicture, .uploadPIC, .gallery:
      return DesignSystem.Icons.gallery
    case .copyLink:
      return DesignSystem.Icons.copy
    default:
      return nil
    }
  }
}

#Preview {
  VStack {
    SmallButton(smallButtonContentType: .changePicture)
    SmallButton(smallButtonContentType: .uploadPIC)
    SmallButton(smallButtonContentType: .gallery)
    SmallButton(smallButtonContentType: .deletePicture)
    SmallButton(type: .constant(.inactive), smallButtonContentType: .deletePicture)
    SmallButton(smallButtonContentType: .copyLink)
    SmallButton(type: .constant(.secondary), smallButtonContentType: .copyLink)
    SmallButton(smallButtonContentType: .changeFrame)
    SmallButton(smallButtonContentType: .stabbing)
    SmallButton(smallButtonContentType: .generateEvent)
    SmallButton(smallButtonContentType: .vote)
  }
}
