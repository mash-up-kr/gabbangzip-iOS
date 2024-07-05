//
//  GroupAPI.swift
//  Services
//
//  Created by YangJoonHyeok on 7/2/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import Foundation
import Get

public enum GroupAPI {
  case getGroups(accessToken: String)
}

extension GroupAPI: RouteType {
  public var path: String {
    switch self {
    case .getGroups:
      return "/api/v1/auth/login"
    }
  }
  
  public var method: HTTPMethod {
    switch self {
    case .getGroups:
      return .get
    }
  }
  
  public var query: [(String, String?)]? {
    switch self {
    case .getGroups:
      return nil
    }
  }
  
  public var body: Encodable? {
    switch self {
    case .getGroups:
      return nil
    }
  }
  
  public var headers: [String: String]? {
    switch self {
    case let .getGroups(accessToken):
      let headers: [String: String]? = [
        "Authorization": "Bearer \(accessToken)"
      ]
      return headers
    }
  }
}
