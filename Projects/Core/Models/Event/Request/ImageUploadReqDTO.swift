//
//  ImageUploadReqDTO.swift
//  Models
//
//  Created by 최혜린 on 8/18/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import Foundation

public struct ImageUploadReqDTO: Encodable {
  public let eventID: Int
  public let imageURLs: [String]
  
  public init(eventID: Int, imageURLs: [String]) {
    self.eventID = eventID
    self.imageURLs = imageURLs
  }
  
  enum CodingKeys: String, CodingKey {
    case eventID = "event_id"
    case imageURLs = "image_urls"
  }
}

