//
//  KakaoAPI.swift
//  Services
//
//  Created by Hyun A Song on 6/22/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import Common
import Foundation
import Models
import Get

public enum KakaoAPI {
  case login(_ idToken: String, _ provider: String, _ nickname: String, _ profileImage: String)
}

extension KakaoAPI: RouteType {
  public var url: URL {
    switch self {
    case .login:
      return URLComponents.createURL(
        scheme: KakaoURL.login.scheme,
        host: KakaoURL.login.host,
        path: KakaoURL.login.path
      )
    }
  }
  
  public var method: HTTPMethod {
    switch self {
    case .login:
      return .post
    }
  }
  
  public var query: [(String, String?)]? {
    switch self {
    case let .login(idToken, provider, nickname, profileImage):
      let query: [(String, String?)]? = [
        ("idToken", "\(idToken)"),
        ("provider", "\(provider)"),
        ("nickname", "\(nickname)"),
        ("profileImage", "\(profileImage)")
      ]
      return query
    }
  }
  
  public var body: Encodable? {
    switch self {
    case .login:
      return nil
    }
  }
  
  public var headers: [String: String]? {
    switch self {
    case .login:
      return nil
    }
  }
  
  public var id: String? {
    switch self {
    case .login:
      return nil
    }
  }
}
