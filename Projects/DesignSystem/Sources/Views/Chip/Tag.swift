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
  
  public init(type: TagType) {
    self.type = type
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
    .background(DesignSystem.Colors.gray40)
    .cornerRadius(20)
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
        .font(.body12)
        .foregroundStyle(DesignSystem.Colors.gray80)
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
      .font(.body12)
      .foregroundStyle(DesignSystem.Colors.gray80)
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
