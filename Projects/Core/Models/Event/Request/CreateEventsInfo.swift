//
//  CreateEventsInfo.swift
//  Models
//
//  Created by Hyun A Song on 8/15/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

public struct CreateEventsInfo: Encodable {
  public let groupID: Int
  public let description: String
  public let date: String
  public let pictures: [String]
  
  public init(
    groupID: Int,
    description: String,
    date: String,
    pictures: [String]
  ) {
    self.groupID = groupID
    self.description = description
    self.date = date
    self.pictures = pictures
  }
  
  enum CodingKeys: String, CodingKey {
    case groupID = "group_id"
    case description
    case date
    case pictures
  }
}
