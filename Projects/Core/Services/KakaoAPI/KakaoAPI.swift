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
  case refresh(refreshToken: String)
  case testToken(accessToken: String)
  case delete(accessToken: String)
}

extension KakaoAPI: RouteType {
  public var path: String {
    switch self {
    case .login:
      return "/api/v1/auth/login"
    case .refresh:
      return "/api/v1/auth/token"
    case .testToken:
      return "/api/test"
    case .delete:
      return "/api/v1/user"
    }
  }
  
  public var method: HTTPMethod {
    switch self {
    case .login:
      return .post
    case .refresh:
      return .post
    case .testToken:
      return .get
    case .delete:
      return .delete
    }
  }
  
  public var query: [(String, String?)]? {
    switch self {
    case .login:
      return nil
    case .refresh:
      return nil
    case .testToken:
      return nil
    case .delete:
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
    case let .refresh(refreshToken):
      return KakaoRefreshRequest(refreshToken: refreshToken)
    case .testToken:
      return nil
    case .delete:
      return nil
    }
  }
  
  public var headers: [String: String]? {
    switch self {
    case .login:
      return nil
    case .refresh:
      return nil
    case let .testToken(accessToken):
      let headers: [String: String]? = [
        "Authorization": "Bearer \(accessToken)"
      ]
      return headers
    case let .delete(accessToken):
      let headers: [String: String]? = [
        "Authorization": "Bearer \(accessToken)"
      ]
      return headers
    }
  }
}
