//
//  FileUploadAPI.swift
//  Services
//
//  Created by YangJoonHyeok on 7/29/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import Get

public enum FileUploadAPI {
  case getUploadURL(accessToken: String, fileExtension: String)
  case createGroup(accessToken: String, groupName: String, keyword: String, groupImageURL: String)
}

extension FileUploadAPI: RouteType {
  public var path: String {
    switch self {
    case .getUploadURL:
      return "/api/v1/files/upload"
    case .createGroup:
      return "/api/v1/groups"
    }
  }
  
  public var method: HTTPMethod {
    switch self {
    case .getUploadURL:
      return .get
    case .createGroup:
      return .post
    }
  }
  
  public var query: [(String, String?)]? {
    switch self {
    case let .getUploadURL(_, fileExtension):
      return [("extension", fileExtension)]
    case .createGroup:
      return nil
    }
  }
  
  public var body: Encodable? {
    switch self {
    case .getUploadURL:
      return nil
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
    case let .getUploadURL(accessToken, _):
      return ["Authorization": "Bearer \(accessToken)"]
    case let .createGroup(accessToken, _, _, _):
      return ["Authorization": "Bearer \(accessToken)"]
    }
  }
}
