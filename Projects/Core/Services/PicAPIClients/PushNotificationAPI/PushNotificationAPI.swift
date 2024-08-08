//
//  PushNotificationAPI.swift
//  Services
//
//  Created by YangJoonHyeok on 8/8/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import Foundation
import Get

public enum PushNotificationAPI {
  case registerFCMToken(accessToken: String, fcmToken: String)
  case kook(accessToken: String, eventID: Int)
}

extension PushNotificationAPI: RouteType {
  public var path: String {
    switch self {
    case .registerFCMToken:
      return "/api/v1/alarm/token"
    case .kook:
      return "/api/v1/alarm/kook"
    }
  }
  
  public var method: HTTPMethod {
    switch self {
    case .registerFCMToken:
      return .post
    case .kook:
      return .post
    }
  }
  
  public var query: [(String, String?)]? {
    switch self {
    case .registerFCMToken:
      return nil
    case .kook:
      return nil
    }
  }
  
  public var body: Encodable? {
    switch self {
    case let .registerFCMToken(_, fcmToken):
      return ["token": fcmToken]
    case let .kook(_, eventID):
      return ["event_id": eventID]
    }
  }
  
  public var headers: [String: String]? {
    switch self {
    case let .registerFCMToken(accessToken, _), let .kook(accessToken, _):
      return ["Authorization": "Bearer \(accessToken)"]
    }
  }
}

