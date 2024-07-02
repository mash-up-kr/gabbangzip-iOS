//
//  KakaoRefreshRequest.swift
//  Models
//
//  Created by Hyun A Song on 6/29/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

public struct KakaoRefreshRequest: Encodable {
  public let refreshToken: String
  
  public init(refreshToken: String) {
    self.refreshToken = refreshToken
  }
  
  enum CodingKeys: String, CodingKey {
    case refreshToken = "refresh_token"
  }
}
