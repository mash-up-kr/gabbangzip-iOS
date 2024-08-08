//
//  RegisteredFCMToken.swift
//  Models
//
//  Created by YangJoonHyeok on 8/8/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import Foundation

public struct RegisteredFCMToken: Decodable {
  public let registedToken: String
  
  enum CodingKeys: String, CodingKey {
    case registedToken = "registed_token"
  }
}

extension RegisteredFCMToken {
  public static let mock = Self(registedToken: "")
}
