//
//  VoteOptionInfo.swift
//  Models
//
//  Created by hyerin on 8/3/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import Foundation

public struct VoteOptionInfo: Decodable {
  public let optionID: Int
  public let imageURL: String
  
  enum CodingKeys: String, CodingKey {
    case optionID = "option_id"
    case imageURL = "image_url"
  }
}
