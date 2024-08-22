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
  case deadline
}

public extension DateFormatter {
  static let iso8601: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
    //formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
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
    case .deadline:
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
  
  static let deadline: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "M월 d일 EEEE H시 m분"
    return formatter
  }()

  static let createEvent: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "YY/MM/dd"
    return formatter
  }()
}

// TEST: - 앱 심사용 테스트 코드
public extension Bool {
  static let forAppReview: Bool = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    dateFormatter.timeZone = TimeZone(identifier: "Asia/Seoul")
    
    guard let deadline = dateFormatter.date(from: "2024-08-24 14:00:00") else {
      return false
    }
    
    return Date() < deadline
  }()
}
