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
  public enum Frame: String, Decodable, Hashable {
    case snowman = "SNOWMAN"
    case plus = "PLUS"
    case ghost = "GHOST"
    case clover = "CLOVER"
    case sexy = "SEXY"
    case flower = "FLOWER"
    case hamburger = "HAMBURGER"
  }
}
