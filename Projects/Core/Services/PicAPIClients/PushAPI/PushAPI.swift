//
//  PushAPI.swift
//  Services
//
//  Created by hyerin on 8/7/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import Common
import Foundation
import Get
import Models

public enum PushAPI {
  case postKook(accessToken: String, eventID: Int)
}

extension PushAPI: RouteType {
  public var path: String {
    switch self {
    case .postKook:
      return "/api/v1/alarm/kook"
    }
  }
  
  public var method: HTTPMethod {
    switch self {
    case .postKook:
      return .post
    }
  }
  
  public var query: [(String, String?)]? {
    switch self {
    case .postKook:
      return nil
    }
  }
  
  public var body: Encodable? {
    switch self {
    case let .postKook(_, eventID):
      let body = ["event_id": eventID]
      return body
    }
  }
  
  public var headers: [String: String]? {
    switch self {
    case let .postKook(accessToken, _):
      let headers: [String: String]? = [
        "Authorization": "Bearer \(accessToken)"
      ]
      return headers
    }
  }
}

