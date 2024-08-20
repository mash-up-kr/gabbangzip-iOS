//
//  String+extensions.swift
//  Common
//
//  Created by YangJoonHyeok on 7/3/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import Foundation

public extension String {
  func toGroupEventDateString(type: DateFormatterType) -> String? {
    guard let date = DateFormatter.iso8601(type).date(from: self) else {
      return nil
    }
    
    switch type {
    case .eventDate:
      return DateFormatter.groupEvent.string(from: date)
    case .deadline:
      return DateFormatter.deadline.string(from: date)
    }
  }
}
