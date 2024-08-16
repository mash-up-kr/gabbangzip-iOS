//
//  EventInfo.swift
//  Models
//
//  Created by Hyun A Song on 8/16/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

public struct EventInfo: Decodable {
  public let eventID: Int
  
  public init(eventID: Int) {
    self.eventID = eventID
  }
  
  enum CodingKeys: String, CodingKey {
    case eventID = "id"
  }
  
  public static let mock: EventInfo = .init(eventID: 0)
}
