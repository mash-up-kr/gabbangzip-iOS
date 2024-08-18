//
//  EventAPI.swift
//  Services
//
//  Created by hyerin on 8/6/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import Models
import Foundation
import Get

public enum EventAPI {
  case putEventVisit(accessToken: String, eventID: Int)
  case postImages(accessToken: String, eventID: Int, imageURLs: [String])
}

extension EventAPI: RouteType {
  public var path: String {
    switch self {
    case .putEventVisit:
      return "/api/v1/events/visit"
    case .postImages:
      return "/api/v1/events/images"
    }
  }
  
  public var method: HTTPMethod {
    switch self {
    case .putEventVisit:
      return .put
    case .postImages:
      return .post
    }
  }
  
  public var query: [(String, String?)]? {
    switch self {
    case .putEventVisit, .postImages:
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
    case let .postImages(_, eventID, imageURLs):
      let body: ImageUploadReqDTO = .init(
        eventID: eventID,
        imageURLs: imageURLs
      )
      return body
    }
  }
  
  public var headers: [String: String]? {
    switch self {
    case let .putEventVisit(accessToken, _), let .postImages(accessToken, _, _):
      let headers: [String: String]? = [
        "Authorization": "Bearer \(accessToken)"
      ]
      return headers
    }
  }
}

