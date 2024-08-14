//
//  VoteOptionInfo.swift
//  Models
//
//  Created by hyerin on 8/3/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import Foundation

public struct VoteOptionInfo: Decodable, Equatable {
    public let options: [Option]
}

// MARK: - Option
public struct Option: Decodable, Equatable {
  public let optionID: Int
  public let imageURL: String
  
  public init(optionID: Int, imageURL: String) {
    self.optionID = optionID
    self.imageURL = imageURL
  }

  enum CodingKeys: String, CodingKey {
    case optionID = "option_id"
    case imageURL = "image_url"
  }
}
