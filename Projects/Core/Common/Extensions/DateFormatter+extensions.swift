//
//  DateFormatter+extensions.swift
//  Common
//
//  Created by GREEN on 6/17/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import Foundation

public extension DateFormatter {
  static let iso8601: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
    formatter.calendar = Calendar(identifier: .iso8601)
    formatter.timeZone = TimeZone(abbreviation: "KST")
    formatter.locale = Locale(identifier: "ko_KR")
    return formatter
  }()
}
