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
  @Binding private var isSelected: Bool
  private var action: () -> Void
  private var backgroundColor: Color {
    isSelected ? DesignSystem.Colors.gray80 : DesignSystem.Colors.gray20
  }
  
  public init(
    type: TagType,
    isSelected: Binding<Bool> = .constant(false),
    action: @escaping () -> Void = {}
  ) {
    self.type = type
    self._isSelected = isSelected
    self.action = action
  }
  
  public var body: some View {
    Button(
      action: {
        isSelected.toggle()
        action()
      },
      label: {
        switch type {
        case let .category(categoryType):
          CategoryTag(
            type: categoryType,
            isSelected: $isSelected
          )
        
        case let .etc(etcType):
          EtcTag(
            type: etcType,
            isSelected: $isSelected
          )
        }
      }
    )
    .background(backgroundColor)
    .cornerRadius(20)
  }
}

// MARK: - 카테고리 태그
fileprivate struct CategoryTag: View {
  private var type: CategoryType
  @Binding private var isSelected: Bool
  private var logoImage: Image {
    isSelected ? type.selectedImage : type.unselectedImage
  }
  private var titleColor: Color {
    isSelected ? DesignSystem.Colors.gray0 : DesignSystem.Colors.gray60
  }
  
  fileprivate init(
    type: CategoryType,
    isSelected: Binding<Bool>
  ) {
    self.type = type
    self._isSelected = isSelected
  }
  
  fileprivate var body: some View {
    HStack(spacing: 4) {
      logoImage
        .resizable()
        .frame(width: 10, height: 10)
      
      Text(type.title)
        .font(.body12)
        .foregroundStyle(titleColor)
    }
    .padding(.vertical, 6)
    .padding(.horizontal, 10)
  }
}

// MARK: - 그 외 태그
fileprivate struct EtcTag: View {
  private var type: EtcType
  @Binding private var isSelected: Bool
  private var titleColor: Color {
    isSelected ? DesignSystem.Colors.gray0 : DesignSystem.Colors.gray60
  }
  
  fileprivate init(
    type: EtcType,
    isSelected: Binding<Bool>
  ) {
    self.type = type
    self._isSelected = isSelected
  }
  
  fileprivate var body: some View {
    Text(type.title)
      .font(.body12)
      .foregroundColor(titleColor)
      .padding(.vertical, 6)
      .padding(.horizontal, 10)
  }
}

// MARK: - DS에 따른 Large Chip 타입 종류
public enum TagType {
  case category(CategoryType)
  case etc(EtcType)
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
      Tag(type: .etc(.voting))
      Tag(type: .etc(.update(3)))
    }
  }
}
