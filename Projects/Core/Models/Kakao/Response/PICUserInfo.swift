//
//  PICUserInfo.swift
//  Models
//
//  Created by Hyun A Song on 6/22/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

public struct PICUserInfo: Decodable {
  public let userID: Int
  public let nickname: String
  public let accessToken: String
  public let refreshToken: String
  
  public enum CodingKeys: String, CodingKey {
    case userID = "user_id"
    case nickname
    case accessToken = "access_token"
    case refreshToken = "refresh_token"
  }
}
