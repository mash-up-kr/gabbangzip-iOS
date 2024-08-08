//
//  Keyword+extensions.swift
//  CreateGroup
//
//  Created by YangJoonHyeok on 7/9/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import DesignSystem
import Models
import SwiftUI

public extension GroupData.Keyword {
  var categoryType: CategoryType {
    switch self {
    case .school:
      return .school
    case .company:
      return .company
    case .crew:
      return .crew
    case .network:
      return .network
    case .exercise:
      return .exercise
    case .hobby:
      return .hobby
    case .littleMoim:
      return .littleMoim
    }
  }
  
  var tagType: TagType {
    switch self {
    case .school:
      return .category(.school)
    case .company:
      return .category(.company)
    case .crew:
      return .category(.crew)
    case .network:
      return .category(.network)
    case .exercise:
      return .category(.exercise)
    case .hobby:
      return .category(.hobby)
    case .littleMoim:
      return .category(.littleMoim)
    }
  }
  
  var frame: Image {
    switch self {
    case .school:
      return DesignSystem.Icons.snowmanFrame
    case .company:
      return DesignSystem.Icons.ghostFrame
    case .crew:
      return DesignSystem.Icons.hamburgerFrame
    case .network:
      return DesignSystem.Icons.plusFrame
    case .exercise:
      return DesignSystem.Icons.sexyFrame
    case .hobby:
      return DesignSystem.Icons.flowerFrame
    case .littleMoim:
      return DesignSystem.Icons.cloverFrame
    }
  }
  
  var backgroundColor: Color {
    switch self {
    case .school:
      return DesignSystem.Colors.conifer20
    case .company:
      return DesignSystem.Colors.magentaPink20
    case .crew:
      return DesignSystem.Colors.mayaBlue20
    case .network:
      return DesignSystem.Colors.coral20
    case .exercise:
      return DesignSystem.Colors.dandelion20
    case .hobby:
      return DesignSystem.Colors.malibu20
    case .littleMoim:
      return DesignSystem.Colors.lavender20
    }
  }
  
  var foregroundColor: Color {
    switch self {
    case .school:
      return DesignSystem.Colors.conifer30
    case .company:
      return DesignSystem.Colors.magentaPink30
    case .crew:
      return DesignSystem.Colors.mayaBlue30
    case .network:
      return DesignSystem.Colors.coral30
    case .exercise:
      return DesignSystem.Colors.dandelion30
    case .hobby:
      return DesignSystem.Colors.malibu30
    case .littleMoim:
      return DesignSystem.Colors.lavender30
    }
  }
  
  func convertToPhotoCardStatus<T: View>() -> PhotoCard<T>.Status {
    switch self {
    case .school:
      return .school
    case .company:
      return .company
    case .crew:
      return .crew
    case .network:
      return .network
    case .exercise:
      return .exercise
    case .hobby:
      return .hobby
    case .littleMoim:
      return .littleMoim
    }
  }
}
