//
//  KeywordButton.swift
//  DesignSystem
//
//  Created by GREEN on 6/25/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import SwiftUI

// MARK: - 키워드 버튼
public struct KeywordButton: View {
  private var type: CategoryType
  @Binding private var isSelected: Bool
  private var action: () -> Void
  private var titleColor: Color {
    isSelected ? DesignSystem.Colors.gray80 : DesignSystem.Colors.gray60
  }
  private var icon: Image {
    isSelected ? type.selectedImage : type.unselectedImage
  }
  private var backgroundColor: Color {
    isSelected ? type.color : DesignSystem.Colors.gray40
  }
  
  public init(
    type: CategoryType,
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
        VStack(spacing: 8) {
          Text(type.title)
            .font(.body16)
            .foregroundStyle(titleColor)
          
          icon
            .resizable()
            .frame(width: 58, height: 58)
        }
        .padding(.vertical, 18)
        .padding(.horizontal, 28)
        .frame(width: 114, height: 118)
        .background(backgroundColor)
        .cornerRadius(20)
      }
    )
  }
}

#Preview {
  HStack {
    VStack {
      KeywordButton(type: .club)
      KeywordButton(type: .community)
      KeywordButton(type: .company)
      KeywordButton(type: .exercise)
      KeywordButton(type: .gathering)
      KeywordButton(type: .hobby)
      KeywordButton(type: .school)
    }
    
    VStack {
      KeywordButton(type: .club, isSelected: .constant(true))
      KeywordButton(type: .community, isSelected: .constant(true))
      KeywordButton(type: .company, isSelected: .constant(true))
      KeywordButton(type: .exercise, isSelected: .constant(true))
      KeywordButton(type: .gathering, isSelected: .constant(true))
      KeywordButton(type: .hobby, isSelected: .constant(true))
      KeywordButton(type: .school, isSelected: .constant(true))
    }
  }
}
