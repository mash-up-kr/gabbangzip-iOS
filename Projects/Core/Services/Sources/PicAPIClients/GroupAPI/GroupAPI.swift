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
  case leaveGroup(accessToken: String, groupID: Int)
}

extension GroupAPI: RouteType {
  public var path: String {
    switch self {
    case .getGroups:
      return "/api/v1/groups"
    case let .getGroupDetail(_, groupID):
      return "/api/v1/groups/\(groupID)"
    case .joinGroup:
      return "/api/v1/groups/join"
    case let .getMemberList(_, groupID):
      return "/api/v1/groups/\(groupID)/members"
    case let .leaveGroup(_, groupID):
      return "/api/v1/groups/\(groupID)/join"
    }
  }
  
  public var method: HTTPMethod {
    switch self {
    case .getGroups, .getGroupDetail, .getMemberList:
      return .get
    case .joinGroup:
      return .post
    case .leaveGroup:
      return .delete
    }
  }
  
  public var query: [(String, String?)]? {
    switch self {
    case .getGroups, .joinGroup, .getMemberList, .getGroupDetail, .leaveGroup:
      return nil
    }
  }
  
  public var body: Encodable? {
    switch self {
    case .getGroups, .getGroupDetail, .getMemberList, .leaveGroup:
      return nil
    case let .joinGroup(_, code):
      return ["code": code]
    }
  }
  
  public var headers: [String: String]? {
    switch self {
    case let .getGroups(accessToken), let .joinGroup(accessToken, _), let .getMemberList(accessToken, _), let .getGroupDetail(accessToken, _), let .leaveGroup(accessToken, _):
      return ["Authorization": "Bearer \(accessToken)"]
    }
  }
}
