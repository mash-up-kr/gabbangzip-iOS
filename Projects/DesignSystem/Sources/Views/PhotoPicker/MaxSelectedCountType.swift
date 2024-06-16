//
//  MaxSelectedCountType.swift
//  DesignSystem
//
//  Created by GREEN on 6/12/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import Foundation

// MARK: - 최대 선택 사진 갯수 타입
public enum MaxSelectedCountType {
  case single
  case multiple
  case custom(Int)
  
  var rawValue: Int {
    switch self {
    case .single:
      return 1
    case .multiple:
      return 6
    case .custom(let value):
      return value
    }
  }
}
