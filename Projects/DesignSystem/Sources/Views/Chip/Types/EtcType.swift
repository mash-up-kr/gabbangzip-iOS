//
//  EtcType.swift
//  DesignSystem
//
//  Created by GREEN on 6/25/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import Foundation

// MARK: - 그 외 타입 (쉿, 투표중 / 최근 업데이트 N일전 / 커스텀)
public enum EtcType {
  case voting
  case update(Int)
  case custom(String)
  
  var title: String {
    switch self {
    case .voting:
      return "쉿, 투표중"
    case let .update(day):
      return "최근 업데이트 \(day)일전"
    case let .custom(text):
      return text
    }
  }
}
