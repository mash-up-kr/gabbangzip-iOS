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
  case joinGroup(accessToken: String, code: String)
}

extension GroupAPI: RouteType {
  public var path: String {
    switch self {
    case .getGroups:
      return "/api/v1/groups"
    case .joinGroup:
      return "/api/v1/groups/join"
    }
  }
  
  public var method: HTTPMethod {
    switch self {
    case .getGroups:
      return .get
    case .joinGroup:
      return .post
    }
  }
  
  public var query: [(String, String?)]? {
    switch self {
    case .getGroups:
      return nil
    case .joinGroup:
      return .none
    }
  }
  
  public var body: Encodable? {
    switch self {
    case .getGroups:
      return nil
    case let .joinGroup(_, code):
      return ["code": code]
    }
  }
  
  public var headers: [String: String]? {
    switch self {
    case let .getGroups(accessToken):
      return ["Authorization": "Bearer \(accessToken)"]
      
    case let .joinGroup(accessToken, _):
      return ["Authorization": "Bearer \(accessToken)"]
    }
  }
}
