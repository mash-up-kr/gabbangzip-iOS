//
//  LargeChip.swift
//  DesignSystem
//
//  Created by GREEN on 6/18/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import SwiftUI

public struct LargeChip: View {
  private var type: LargeChipType
  @Binding private var isSelected: Bool
  private var action: () -> Void
  private var backgroundColor: Color {
    isSelected ? DesignSystem.Colors.gray80 : DesignSystem.Colors.gray40
  }
  
  public init(
    type: LargeChipType,
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
          CategoryChip(
            type: categoryType,
            isSelected: $isSelected
          )
          
        case let .time(timeType):
          TimeChip(
            type: timeType,
            isSelected: $isSelected
          )
        }
      }
    )
    .background(backgroundColor)
    .cornerRadius(20)
  }
}

// MARK: - 카테고리 칩
fileprivate struct CategoryChip: View {
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
    HStack(spacing: 8) {
      logoImage
        .resizable()
        .frame(width: 14, height: 14)
      
      Text(type.title)
        .font(.body14)
        .foregroundStyle(titleColor)
    }
    .padding(.vertical, 8)
    .padding(.horizontal, 12)
  }
}

// MARK: - 시간 칩
fileprivate struct TimeChip: View {
  private var type: TimeType
  @Binding private var isSelected: Bool
  private var titleColor: Color {
    isSelected ? DesignSystem.Colors.gray0 : DesignSystem.Colors.gray60
  }
  
  fileprivate init(
    type: TimeType,
    isSelected: Binding<Bool>
  ) {
    self.type = type
    self._isSelected = isSelected
  }
  
  fileprivate var body: some View {
    Text("\(type.rawValue)시간 뒤")
      .font(.body14)
      .foregroundStyle(titleColor)
      .padding(.vertical, 10)
      .padding(.horizontal, 12)
  }
}

// MARK: - DS에 따른 Large Chip 타입 종류
public enum LargeChipType {
  case category(CategoryType)
  case time(TimeType)
}
