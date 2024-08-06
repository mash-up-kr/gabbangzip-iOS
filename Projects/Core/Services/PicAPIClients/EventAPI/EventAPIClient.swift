//
//  EventAPIClient.swift
//  Services
//
//  Created by hyerin on 8/6/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import ComposableArchitecture
import Foundation
import Get
import Models

@DependencyClient
public struct EventAPIClient: Sendable {
  public var putEventVisit: @Sendable (_ accessToken: String, _ eventID: Int) async throws -> EventVisitInfo
}

extension EventAPIClient: DependencyKey {
  public static var liveValue: EventAPIClient {
    return EventAPIClient(
      putEventVisit: { accessToken, eventID in
        let route = EventAPI.putEventVisit(accessToken: accessToken, eventID: eventID)
        let request = Request<SuccessResponse<EventVisitInfo>>(route: route)
        do {
          let response = try await NetworkManager.shared.send(request)
          return response.value.data
        } catch {
          throw EventAPIClientError(
            code: .failToPutEventVisit,
            underlying: error
          )
        }
      }
    )
  }
  
  public static var previewValue: EventAPIClient {
    return EventAPIClient(
      putEventVisit: { accessToken, eventID in
        return EventVisitInfo.mock
      }
    )
  }
}

extension DependencyValues {
  public var eventAPIClient: EventAPIClient {
    get { self[EventAPIClient.self] }
    set { self[EventAPIClient.self] = newValue }
  }
}

// MARK: - KakaoAPIClientError
public struct EventAPIClientError: GabbangzipError {
  public var userInfo: [String: Any] = [:]
  public var code: APIResponseError
  public var underlying: Error?

  public enum APIResponseError: Int {
    case failToPutEventVisit
  }
}
