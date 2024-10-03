//
//  Tag.swift
//  DesignSystem
//
//  Created by GREEN on 6/18/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import SwiftUI

public struct Tag: View {
  private var type: TagType
  private var displayMode: DisplayMode
  private var font: Font
  
  public init(
    type: TagType,
    displayMode: DisplayMode = .light,
    font: Font = .body12
  ) {
    self.type = type
    self.displayMode = displayMode
    self.font = font
  }
  
  public var body: some View {
    Group {
      switch type {
      case let .category(categoryType):
        CategoryTag(
          type: categoryType
        )
        
      case let .etc(etcType):
        EtcTag(
          type: etcType
        )
      }
    }
    .font(font)
    .foregroundStyle(textColor)
    .background(chipColor)
    .cornerRadius(20)
  }
  
  private var textColor: Color {
    switch displayMode {
    case .light:
      return DesignSystem.Colors.gray80
    case .dark:
      return DesignSystem.Colors.gray40
    }
  }
  
  private var chipColor: Color {
    switch displayMode {
    case .light:
      return DesignSystem.Colors.gray40
    case .dark:
      return DesignSystem.Colors.gray100
    }
  }
}

// MARK: - 카테고리 태그
fileprivate struct CategoryTag: View {
  private var type: CategoryType
  
  fileprivate init(type: CategoryType) {
    self.type = type
  }
  
  fileprivate var body: some View {
    HStack(spacing: 4) {
      type.selectedImage
        .resizable()
        .frame(width: 10, height: 10)
      
      Text(type.title)
//        .font(.body12)
    }
    .padding(.vertical, 6)
    .padding(.horizontal, 10)
  }
}

// MARK: - 그 외 태그
fileprivate struct EtcTag: View {
  private var type: EtcType
  
  fileprivate init(type: EtcType) {
    self.type = type
  }
  
  fileprivate var body: some View {
    Text(type.title)
//      .font(.body12)
      .padding(.vertical, 6)
      .padding(.horizontal, 10)
  }
}

// MARK: - DS에 따른 Large Chip 타입 종류
public enum TagType {
  case category(CategoryType)
  case etc(EtcType)
}

public enum DisplayMode {
  case light
  case dark
}

#Preview {
  HStack {
    VStack {
      Tag(type: .category(.crew))
      Tag(type: .category(.network))
      Tag(type: .category(.company))
      Tag(type: .category(.exercise))
      Tag(type: .category(.littleMoim))
      Tag(type: .category(.hobby))
      Tag(type: .category(.school))
    }
    
    VStack {
      Tag(type: .category(.crew), displayMode: .dark)
      Tag(type: .category(.network), displayMode: .dark)
      Tag(type: .category(.company), displayMode: .dark)
      Tag(type: .category(.exercise), displayMode: .dark)
      Tag(type: .category(.littleMoim), displayMode: .dark)
      Tag(type: .category(.hobby), displayMode: .dark)
      Tag(type: .category(.school), displayMode: .dark)
    }
    
    VStack {
      Tag(type: .etc(.voting))
      Tag(type: .etc(.update(3)))
    }
    
    VStack {
      Tag(type: .etc(.voting), displayMode: .dark)
      Tag(type: .etc(.update(3)), displayMode: .dark)
    }
  }
}
