//
//  VoteOptionInfo.swift
//  Models
//
//  Created by hyerin on 8/3/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

public struct VoteOptionInfo: Decodable, Equatable {
  public let optionID: Int
  public let imageURL: String
  
  enum CodingKeys: String, CodingKey {
    case optionID = "option_id"
    case imageURL = "image_url"
  }
  
  public init(optionID: Int, imageURL: String) {
    self.optionID = optionID
    self.imageURL = imageURL
  }
  
  public static let emptyItem: VoteOptionInfo = .init(optionID: 0, imageURL: "")
}
