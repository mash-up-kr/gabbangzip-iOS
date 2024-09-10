//
//  AppleLoginAPI.swift
//  Models
//
//  Created by hyerin on 9/10/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import Common
import Foundation
import Get
import Models

public enum AppleLoginAPI {
  case requestToken(
    clientID: String,
    clientSecret: String,
    authorizationCode: String
  )
  case revoke(
    clientID: String,
    clientSecret: String,
    token: String
  )
}

extension AppleLoginAPI: RouteType {
  public var path: String {
    switch self {
    case .revoke:
      return "/auth/revoke"
    case .requestToken:
      return "/auth/token"
    }
  }
  
  public var method: HTTPMethod {
    switch self {
    case .revoke, .requestToken:
      return .post
    }
  }
  
  public var query: [(String, String?)]? {
    switch self {
    case let .revoke(clientID, clientSecret, token):
      return [
        ("client_id", clientID),
        ("client_secret", clientSecret),
        ("token", token)
      ]
    case let .requestToken(clientID, clientSecret, authorizationCode):
      return [
        ("client_id", clientID),
        ("client_secret", clientSecret),
        ("code", authorizationCode),
        ("grant_type", "autorization_code")
      ]
    }
  }
  
  public var body: Encodable? {
    switch self {
    case .revoke, .requestToken:
      return nil
    }
  }
  
  public var headers: [String: String]? {
    switch self {
    case .revoke, .requestToken:
      let headers: [String: String]? = [
        "Content-Type": "application/x-www-form-urlencoded"
      ]
      return headers
    }
  }
}

