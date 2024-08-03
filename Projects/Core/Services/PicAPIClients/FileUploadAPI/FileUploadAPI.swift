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
}

extension FileUploadAPI: RouteType {
  public var path: String {
    switch self {
    case .getUploadURL:
      return "/api/v1/files/upload"
    }
  }
  
  public var method: HTTPMethod {
    switch self {
    case .getUploadURL:
      return .get
    }
  }
  
  public var query: [(String, String?)]? {
    switch self {
    case let .getUploadURL(_, fileExtension):
      return [("extension", fileExtension)]
    }
  }
  
  public var body: Encodable? {
    switch self {
    case .getUploadURL:
      return nil
    }
  }
  
  public var headers: [String: String]? {
    switch self {
    case let .getUploadURL(accessToken, _):
      return ["Authorization": "Bearer \(accessToken)"]
    }
  }
}
