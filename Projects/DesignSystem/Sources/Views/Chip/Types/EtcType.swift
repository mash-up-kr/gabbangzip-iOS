//
//  EtcType.swift
//  DesignSystem
//
//  Created by GREEN on 6/25/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import Foundation

// MARK: - 그 외 타입 (쉿, 투표중 / N일전 업데이트)
public enum EtcType {
  case voting
  case update(Int)
  
  var title: String {
    switch self {
    case .voting:
      return "쉿, 투표중"
    case let .update(day):
      return "\(day)일전 업데이트"
    }
  }
}
