//
//  CategoryType.swift
//  DesignSystem
//
//  Created by GREEN on 6/18/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import SwiftUI

// MARK: - 카테고리 타입 (학교, 동아리, 회사, 소모임, 친목, 취미, 운동)
public enum CategoryType {
  case school
  case club
  case company
  case gathering
  case community
  case hobby
  case exercise
  
  var title: String {
    switch self {
    case .school:
      return "학교"
    case .club:
      return "동아리"
    case .company:
      return "회사"
    case .gathering:
      return "소모임"
    case .community:
      return "친목"
    case .hobby:
      return "취미"
    case .exercise:
      return "운동"
    }
  }
  
  var selectedImage: Image {
    switch self {
    case .school:
      return DesignSystem.Icons.schoolActive
    case .club:
      return DesignSystem.Icons.clubActive
    case .company:
      return DesignSystem.Icons.companyActive
    case .gathering:
      return DesignSystem.Icons.gatheringActive
    case .community:
      return DesignSystem.Icons.communityActive
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
    case .club:
      return DesignSystem.Icons.clubInactive
    case .company:
      return DesignSystem.Icons.companyInactive
    case .gathering:
      return DesignSystem.Icons.gatheringInactive
    case .community:
      return DesignSystem.Icons.communityInactive
    case .hobby:
      return DesignSystem.Icons.hobbyInactive
    case .exercise:
      return DesignSystem.Icons.exerciseInactive
    }
  }
}
