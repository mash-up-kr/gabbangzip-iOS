//
//  TokenInformation.swift
//  Models
//
//  Created by Hyun A Song on 6/30/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

public struct TokenInformation: Decodable {
  public let accessToken: String
  public let refreshToken: String
  
  enum CodingKeys: String, CodingKey {
    case accessToken = "access_token"
    case refreshToken = "refresh_token"
  }
}
