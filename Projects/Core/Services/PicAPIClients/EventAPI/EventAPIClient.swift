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
  public var putEventVisit: @Sendable (
    _ accessToken: String,
    _ eventID: Int
  ) async throws -> EventVisitInfo
  public var createEvent: @Sendable (
    _ accessToken: String,
    _ groupID: Int,
    _ description: String,
    _ date: String,
    _ pictures: [String]
  ) async throws -> EventInfo
  public var uploadEventImages: @Sendable (
    _ accessToken: String,
    _ eventID: Int,
    _ imageURLs: [String]) async throws -> EventImageInfo
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
      },
      createEvent: { accessToken, groupID, description, date, pictures in
        let route = EventAPI.createEvent(
          accessToken: accessToken,
          groupID: groupID,
          description: description,
          date: date,
          pictures: pictures
        )
        let request = Request<SuccessResponse<EventInfo>>(route: route)
        do {
          let response = try await NetworkManager.shared.send(request)
          return response.value.data
        } catch {
          throw EventAPIClientError(
            code: .failToCreateEvent,
            underlying: error
          )
        }
      },
      uploadEventImages: { accessToken, eventID, imageURLs in
        let route = EventAPI.uploadEventImages(
          accessToken: accessToken,
          eventID: eventID,
          imageURLs: imageURLs
        )
        let request = Request<SuccessResponse<EventImageInfo>>(route: route)
        do {
          let response = try await NetworkManager.shared.send(request)
          return response.value.data
        } catch {
          throw EventAPIClientError(
            code: .failTpUploadEventImage,
            underlying: error
          )
        }
      }
    )
  }
  
  public static var previewValue: EventAPIClient {
    return EventAPIClient(
      putEventVisit: { _, _ in
        return EventVisitInfo.mock
      },
      createEvent: { _, _, _, _, _ in
        return EventInfo.mock
      },
      uploadEventImages: { _, _, _ in
        return EventImageInfo.mock
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
    case failToCreateEvent
    case failTpUploadEventImage
  }
}
