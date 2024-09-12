//
//  CreateGroupAPI.swift
//  Services
//
//  Created by YangJoonHyeok on 8/1/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import Get

public enum CreateGroupAPI {
  case createGroup(accessToken: String, groupName: String, keyword: String, groupImageURL: String)
}

extension CreateGroupAPI: RouteType {
  public var path: String {
    switch self {
    case .createGroup:
      return "/api/v1/groups"
    }
  }
  
  public var method: HTTPMethod {
    switch self {
    case .createGroup:
      return .post
    }
  }
  
  public var query: [(String, String?)]? {
    switch self {
    case .createGroup:
      return nil
    }
  }
  
  public var body: Encodable? {
    switch self {
    case let .createGroup(_, groupName, keyword, groupImageURL):
      return [
        "group_name": groupName,
        "keyword": keyword,
        "group_image_url": groupImageURL
      ]
    }
  }
  
  public var headers: [String: String]? {
    switch self {
    case let .createGroup(accessToken, _, _, _):
      return ["Authorization": "Bearer \(accessToken)"]
    }
  }
}
