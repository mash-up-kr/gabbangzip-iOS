//
//  UploadEventImageInfo.swift
//  Models
//
//  Created by Hyun A Song on 8/16/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

public struct UploadEventImageInfo: Encodable {
  public let eventID: Int
  public let imageURLs: [String]
  
  public init(
    eventID: Int,
    imageURLs: [String]
  ) {
    self.eventID = eventID
    self.imageURLs = imageURLs
  }
  
  enum CodingKeys: String, CodingKey {
    case eventID = "event_id"
    case imageURLs = "image_urls"
  }
}
