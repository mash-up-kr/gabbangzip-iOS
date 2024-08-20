//
//  ImageUploadInfo.swift
//  Models
//
//  Created by 최혜린 on 8/18/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import Foundation

public struct ImageUploadInfo: Decodable {
  public var eventID: Int
  
  enum CodingKeys: String, CodingKey {
    case eventID = "event_id"
  }
  
  public static var mock: ImageUploadInfo = .init(
    eventID: -1
  )
}
