//
//  KakaoAPI.swift
//  Services
//
//  Created by Hyun A Song on 6/22/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import Common
import Foundation
import Get
import Models

public enum KakaoAPI {
  case login(
    idToken: String,
    provider: String,
    nickname: String,
    profileImage: String
  )
  case withdraw(_ accessToken: String)
}

extension KakaoAPI: RouteType {
  public var path: String {
    switch self {
    case .login:
      return "/api/v1/auth/login"
    case .withdraw:
      return "/api/v1/auth/token"
    }
  }
  
  public var method: HTTPMethod {
    switch self {
    case .login:
      return .post
    case .withdraw:
      return .delete
    }
  }
  
  public var query: [(String, String?)]? {
    switch self {
    case .login:
      return nil
    case .withdraw:
      return nil
    }
  }
  
  public var body: Encodable? {
    switch self {
    case let .login(idToken, provider, nickname, profileImage):
      let body = KakaoLoginRequestInformation(
        idToken: idToken,
        provider: provider,
        nickname: nickname,
        profileImage: profileImage
      )
      return body
    case .withdraw:
      return nil
    }
  }
  
  public var headers: [String: String]? {
    switch self {
    case .login:
      return nil
    case let .withdraw(accessToken):
      let headers: [String: String]? = [
        "Authorization": "Bearer \(accessToken)"
      ]
      return headers
    }
  }
}
