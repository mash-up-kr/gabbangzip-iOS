//
//  DateFormatter+extensions.swift
//  Common
//
//  Created by GREEN on 6/17/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import Foundation

public enum DateFormatterType {
  case eventDate
  case deadLine
}

public extension DateFormatter {
  static let iso8601: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
    formatter.calendar = Calendar(identifier: .iso8601)
    formatter.timeZone = TimeZone(abbreviation: "KST")
    formatter.locale = Locale(identifier: "ko_KR")
    return formatter
  }()

  
  static func iso8601(
    _ type: DateFormatterType = .eventDate
  ) -> DateFormatter {
    let formatter = DateFormatter()
    
    switch type {
    case .eventDate:
      formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
    case .deadLine:
      formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
    }
    
    formatter.calendar = Calendar(identifier: .iso8601)
    formatter.timeZone = TimeZone(abbreviation: "KST")
    formatter.locale = Locale(identifier: "ko_KR")
    return formatter
  }
  
  static let groupEvent: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy.MM.dd"
    return formatter
  }()
}
