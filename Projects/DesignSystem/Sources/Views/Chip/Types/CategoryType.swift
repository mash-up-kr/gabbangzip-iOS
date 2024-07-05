//
//  CategoryType.swift
//  DesignSystem
//
//  Created by GREEN on 6/18/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import SwiftUI

// MARK: - 카테고리 타입 (학교, 동아리, 회사, 소모임, 친목, 취미, 운동)
public enum CategoryType: String {
  case school
  case crew
  case company
  case littleMoim
  case network
  case hobby
  case exercise
  
  var title: String {
    switch self {
    case .school:
      return "학교"
    case .crew:
      return "동아리"
    case .company:
      return "회사"
    case .littleMoim:
      return "소모임"
    case .network:
      return "친목"
    case .hobby:
      return "취미"
    case .exercise:
      return "운동"
    }
  }
  
  public var selectedImage: Image {
    switch self {
    case .school:
      return DesignSystem.Icons.schoolActive
    case .crew:
      return DesignSystem.Icons.crewActive
    case .company:
      return DesignSystem.Icons.companyActive
    case .littleMoim:
      return DesignSystem.Icons.littleMoimActive
    case .network:
      return DesignSystem.Icons.networkActive
    case .hobby:
      return DesignSystem.Icons.hobbyActive
    case .exercise:
      return DesignSystem.Icons.exerciseActive
    }
  }
  
  var unselectedImage: Image {
    switch self {
    case .school:
      return DesignSystem.Icons.schoolInactive
    case .crew:
      return DesignSystem.Icons.crewInactive
    case .company:
      return DesignSystem.Icons.companyInactive
    case .littleMoim:
      return DesignSystem.Icons.littleMoimInactive
    case .network:
      return DesignSystem.Icons.networkInactive
    case .hobby:
      return DesignSystem.Icons.hobbyInactive
    case .exercise:
      return DesignSystem.Icons.exerciseInactive
    }
  }
  
  // 고유 카테고리 컬러
  var color: Color {
    switch self {
    case .school:
      return DesignSystem.Colors.conifer30
    case .crew:
      return DesignSystem.Colors.mayaBlue30
    case .company:
      return DesignSystem.Colors.magentaPink30
    case .littleMoim:
      return DesignSystem.Colors.lavender30
    case .network:
      return DesignSystem.Colors.coral30
    case .hobby:
      return DesignSystem.Colors.malibu30
    case .exercise:
      return DesignSystem.Colors.dandelion30
    }
  }
}
