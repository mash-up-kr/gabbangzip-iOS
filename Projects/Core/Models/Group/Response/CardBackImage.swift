//
//  CardBackImage.swift
//  Models
//
//  Created by YangJoonHyeok on 7/5/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import Foundation

public struct CardBackImage: Decodable, Hashable {
  public let imageURL: String
  public let frame: Frame
  
  enum CodingKeys: String, CodingKey {
    case imageURL = "image_url"
    case frame
  }
}

extension CardBackImage {
  public enum Frame: Decodable, Hashable {
    case snowman
    case plus
    case ghost
    case clover
    case sexy
    case flower
    case hamburger
    
    public init(from decoder: Decoder) throws {
      let container = try decoder.singleValueContainer()
      let rawValue = try container.decode(String.self)
      switch rawValue {
      case "SNOWMAN":
        self = .snowman
      case "PLUS":
        self = .plus
      case "GHOST":
        self = .ghost
      case "CLOVER":
        self = .clover
      case "SEXY":
        self = .sexy
      case "FLOWER":
        self = .flower
      case "HAMBURGER":
        self = .hamburger
      default:
        throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid frame value")
      }
    }
  }
}
