//
//  RegisteredFCMToken.swift
//  Models
//
//  Created by YangJoonHyeok on 8/8/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

public struct RegisteredFCMToken: Decodable {
  public let registeredToken: String
  
  enum CodingKeys: String, CodingKey {
    case registeredToken = "registered_token"
  }
}

extension RegisteredFCMToken {
  public static let mock = Self(registeredToken: "")
}
