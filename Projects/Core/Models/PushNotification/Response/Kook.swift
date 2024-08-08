//
//  Kook.swift
//  Models
//
//  Created by YangJoonHyeok on 8/8/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import Foundation

public struct Kook: Codable {
  public let eventID: Int
  
  enum CodingKeys: String, CodingKey {
    case eventID = "event_id"
  }
}

extension Kook {
  public static let mock = Self(eventID: 0)
}
