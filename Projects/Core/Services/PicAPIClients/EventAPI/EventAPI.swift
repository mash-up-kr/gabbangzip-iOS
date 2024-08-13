//
//  EventAPI.swift
//  Services
//
//  Created by hyerin on 8/6/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import Foundation
import Get

public enum EventAPI {
  case putEventVisit(accessToken: String, eventID: Int)
}

extension EventAPI: RouteType {
  public var path: String {
    switch self {
    case .putEventVisit:
      return "/api/v1/events/visit"
    }
  }
  
  public var method: HTTPMethod {
    switch self {
    case .putEventVisit:
      return .put
    }
  }
  
  public var query: [(String, String?)]? {
    switch self {
    case .putEventVisit:
      return nil
    }
  }
  
  public var body: Encodable? {
    switch self {
    case let .putEventVisit(_, eventID):
      let body = [
        "event_id": eventID
      ]
      return body
    }
  }
  
  public var headers: [String: String]? {
    switch self {
    case let .putEventVisit(accessToken, eventID):
      let headers: [String: String]? = [
        "Authorization": "Bearer \(accessToken)"
      ]
      return headers
    }
  }
}

