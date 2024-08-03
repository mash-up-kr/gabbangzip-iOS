//
//  VoteCompleteInfo.swift
//  Models
//
//  Created by hyerin on 8/3/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import Foundation

public struct VoteCompleteInfo: Decodable {
  public var eventID: Int
  
  enum CodingKeys: String, CodingKey {
    case eventID = "event_id"
  }
}
