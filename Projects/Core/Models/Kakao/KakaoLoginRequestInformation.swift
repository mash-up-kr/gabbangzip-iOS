//
//  KakaoLoginRequestInformation.swift
//  Models
//
//  Created by Hyun A Song on 6/24/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

public struct KakaoLoginRequestInformation: Encodable {
  public let idToken: String
  public let provider: String
  public let nickname: String
  public let profileImage: String
  
  public init(idToken: String, provider: String, nickname: String, profileImage: String) {
    self.idToken = idToken
    self.provider = provider
    self.nickname = nickname
    self.profileImage = profileImage
  }
}
