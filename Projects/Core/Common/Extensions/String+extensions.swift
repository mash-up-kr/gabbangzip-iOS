//
//  String+extensions.swift
//  Common
//
//  Created by YangJoonHyeok on 7/3/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import Foundation

public extension String {
  func toGroupEventDateString() -> String? {
    guard let date = DateFormatter.iso8601.date(from: self) else {
      return nil
    }
    return DateFormatter.groupEvent.string(from: date)
  }
}
