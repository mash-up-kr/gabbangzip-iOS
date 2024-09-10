//
//  AppleLoginAPIClient.swift
//  Services
//
//  Created by hyerin on 9/10/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import ComposableArchitecture
import Foundation
import Get
import Models

@DependencyClient
public struct AppleLoginAPIClient: Sendable {
  public var revoke: @Sendable (
    _ clientID: String,
    _ clientSecret: String,
    _ token: String
  ) async throws -> Void
}

extension AppleLoginAPIClient: DependencyKey {
  public static var liveValue: AppleLoginAPIClient {
    return AppleLoginAPIClient(
      revoke: { clientID, clientSecret, token in
        let route = AppleLoginAPI.revoke(
          clientID: clientID,
          clientSecret: clientSecret,
          token: token
        )
        let request = Request<Void>(route: route)
        do {
          let response = try await AppleNetworkManager.shared.send(request)
          
          return response.value
        } catch {
          throw AppleLoginAPIClientError(code: .failToRevokeAppleID)
        }
      }
    )
  }
}

extension DependencyValues {
  public var appleLoginAPIClient: AppleLoginAPIClient {
    get { self[AppleLoginAPIClient.self] }
    set { self[AppleLoginAPIClient.self] = newValue }
  }
}

public struct AppleLoginAPIClientError: GabbangzipError {
  public var userInfo: [String: Any] = [:]
  public var code: APIResponseError
  public var underlying: Error?

  public enum APIResponseError: Int {
    case failToRevokeAppleID
  }
}

