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
  case getMemberList(accessToken: String, groupID: Int)
  case getGroupDetail(accessToken: String, groupID: Int)
}

extension GroupAPI: RouteType {
  public var path: String {
    switch self {
    case .getGroups, .getGroupDetail:
      return "/api/v1/groups"
    case .joinGroup:
      return "/api/v1/groups/join"
    case let .getMemberList(_, groupID):
      return "/api/v1/groups/\(groupID)/members"
    }
  }
  
  public var method: HTTPMethod {
    switch self {
    case .getGroups, .getGroupDetail, .getMemberList:
      return .get
    case .joinGroup:
      return .post
    }
  }
  
  public var query: [(String, String?)]? {
    switch self {
    case .getGroups, .joinGroup, .getMemberList:
      return nil
    case let .getGroupDetail(_, groupID):
      return [("groupId", String(groupID))]
    }
  }
  
  public var body: Encodable? {
    switch self {
    case .getGroups, .getGroupDetail, .getMemberList:
      return nil
    case let .joinGroup(_, code):
      return ["code": code]
    }
  }
  
  public var headers: [String: String]? {
    switch self {
    case let .getGroups(accessToken), let .joinGroup(accessToken, _), let .getMemberList(accessToken, _), let .getGroupDetail(accessToken, _):
      return ["Authorization": "Bearer \(accessToken)"]
    }
  }
}
