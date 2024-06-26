//
//  PICUserInformation.swift
//  Models
//
//  Created by Hyun A Song on 6/22/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

public struct PICUserInformation: Decodable {
  public let userID: Int
  public let nickname: String
  public let accessToken: String
  public let refreshToken: String
  
  public enum CodingKeys: String, CodingKey {
    case userID = "userId"
    case nickname
    case accessToken
    case refreshToken
  }
}
