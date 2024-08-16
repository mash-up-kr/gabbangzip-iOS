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
  case uploadEventImages(accessToken: String, eventID: Int, imageURL: [String])
}

extension EventAPI: RouteType {
  public var path: String {
    switch self {
    case .putEventVisit:
      return "/api/v1/events/visit"
    case .createEvent:
      return "/api/v1/events"
    case .uploadEventImages:
      return "/api/v1/events/images"
    }
  }
  
  public var method: HTTPMethod {
    switch self {
    case .putEventVisit:
      return .put
    case .createEvent, .uploadEventImages:
      return .post
    }
  }
  
  public var query: [(String, String?)]? {
    switch self {
    case .putEventVisit, .createEvent, .uploadEventImages:
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
    case let .uploadEventImages(_, eventID, imageURL):
      let body = UploadEventImageInfo(
        eventID: eventID,
        imageURL: imageURL
      )
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
    case let .createEvent(accessToken: accessToken, groupID: _, description: _, date: _, pictures: _),
      let .uploadEventImages(accessToken: accessToken, eventID: _, imageURL: _):
      return ["Authorization": "Bearer \(accessToken)"]
    }
  }
}

