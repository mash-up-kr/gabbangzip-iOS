//
//  PushAPIClienet.swift
//  Services
//
//  Created by hyerin on 8/7/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import ComposableArchitecture
import Foundation
import Get
import Models

@DependencyClient
public struct PushAPIClient: Sendable {
  public var postKook: @Sendable (_ accessToken: String, _ eventID: Int) async throws -> KookInfo
}

extension PushAPIClient: DependencyKey {
  public static var liveValue: PushAPIClient {
    return PushAPIClient(
      postKook: { accessToken, eventID in
        let route = PushAPI.postKook(accessToken: accessToken, eventID: eventID)
        let request = Request<SuccessResponse<KookInfo>>(route: route)
        do {
          let response = try await NetworkManager.shared.send(request)
          return response.value.data
        } catch {
          throw PushAPIClientError(
            code: .failToPostKook,
            underlying: error
          )
        }
      }
    )
  }
}

extension DependencyValues {
  public var pushAPIClient: PushAPIClient {
    get { self[PushAPIClient.self] }
    set { self[PushAPIClient.self] = newValue }
  }
}

public struct PushAPIClientError: GabbangzipError {
  public var userInfo: [String: Any] = [:]
  public var code: APIResponseError
  public var underlying: Error?

  public enum APIResponseError: Int {
    case failToPostKook
  }
}

