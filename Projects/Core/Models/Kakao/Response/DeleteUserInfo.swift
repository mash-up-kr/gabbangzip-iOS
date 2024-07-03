//
//  DeleteUserInfo.swift
//  Models
//
//  Created by Hyun A Song on 6/30/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

public struct DeleteUserInfo: Decodable {
  public let userID: Int
  
  enum CodingKeys: String, CodingKey {
    case userID = "user_id"
  }
}
