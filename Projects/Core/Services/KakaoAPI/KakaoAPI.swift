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
  case login(_ idToken: String, _ provider: String, _ nickname: String, _ profileImage: String)
  case authTest(_ accessToken: String)
}

extension KakaoAPI: RouteType {
  public var url: URL {
    switch self {
    case .login:
      return URLComponents.createURL(
        scheme: KakaoURL.login.scheme,
        host: KakaoURL.login.host,
        path: KakaoURL.login.path,
        port: KakaoURL.login.port
      )
    case .authTest:
      return URLComponents.createURL(
        scheme: KakaoURL.authTest.scheme,
        host: KakaoURL.authTest.host,
        path: KakaoURL.authTest.path,
        port: KakaoURL.authTest.port
      )
    }
  }
  
  public var method: HTTPMethod {
    switch self {
    case .login:
      return .post
    case .authTest:
      return .get
    }
  }
  
  public var query: [(String, String?)]? {
    switch self {
    case .login, .authTest:
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
    case .authTest:
      return nil
    }
  }
  
  public var headers: [String: String]? {
    switch self {
    case .login:
      return ["Content-Type": "application/json"]
    case let .authTest(accessToken):
      let query: [String: String]? = [
        "Authorization": "Bearer \(accessToken)"
      ]
      return query
    }
  }
  
  public var id: String? {
    switch self {
    case .login:
      return nil
    case .authTest:
      return nil
    }
  }
}
