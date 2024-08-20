//
//  EventAPI.swift
//  Services
//
//  Created by hyerin on 8/6/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import Foundation
import Get
import Models

public enum EventAPI {
  case putEventVisit(accessToken: String, eventID: Int)
  case createEvent(accessToken: String, groupID: Int, description: String, date: String, pictures: [String])
  case postImages(accessToken: String, eventID: Int, imageURLs: [String])
}

extension EventAPI: RouteType {
  public var path: String {
    switch self {
    case .putEventVisit:
      return "/api/v1/events/visit"
    case .createEvent:
      return "/api/v1/events"
    case .postImages:
      return "/api/v1/events/images"
    }
  }
  
  public var method: HTTPMethod {
    switch self {
    case .putEventVisit:
      return .put
    case .createEvent, .postImages:
      return .post
    }
  }
  
  public var query: [(String, String?)]? {
    switch self {
    case .putEventVisit, .createEvent, .postImages:
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
    case let .createEvent(_, groupID, description, date, pictures):
      let body = CreateEventsInfo(
        groupID: groupID,
        description: description,
        date: date,
        pictures: pictures
      )
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
    case let .putEventVisit(accessToken, _),
      let .createEvent(accessToken, _, _, _, _),
      let .postImages(accessToken, _, _):
      let headers: [String: String]? = [
        "Authorization": "Bearer \(accessToken)"
      ]
      return headers
    }
  }
}

