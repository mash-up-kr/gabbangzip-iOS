//
//  VoteReqDTO.swift
//  Models
//
//  Created by hyerin on 8/3/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

public struct VoteReqDTO: Encodable {
  public let eventID: Int
  public let likedOptionIDs: [Int]
  
  public init(eventID: Int, likedOptionIDs: [Int]) {
    self.eventID = eventID
    self.likedOptionIDs = likedOptionIDs
  }
  
  enum CodingKeys: String, CodingKey {
    case eventID = "event_id"
    case likedOptionIDs = "liked_option_ids"
  }
}
