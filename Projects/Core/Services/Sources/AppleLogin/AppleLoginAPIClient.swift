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
  public var requestToken: @Sendable (_ clientID: String, _ authorizationCode: String) async throws -> AppleTokenInfo
  public var revoke: @Sendable (_ clientID: String, _ token: String) async throws -> Void
}

extension AppleLoginAPIClient: DependencyKey {
  public static var liveValue: AppleLoginAPIClient {
    return AppleLoginAPIClient(
      requestToken: { clientID, authorizationCode in
        let clientSecret = JWTGenerator.shared.makeJWT()
        let route = AppleLoginAPI.requestToken(
          clientID: clientID,
          clientSecret: clientSecret,
          authorizationCode: authorizationCode
        )
        let request = Request<AppleTokenInfo>(route: route)
        do {
          let response = try await AppleNetworkManager.shared.send(request)
          return response.value
        } catch {
          throw AppleLoginAPIClientError(code: .failToRequestToken, underlying: error)
        }
      },
      revoke: { clientID, token in
        let clientSecret = JWTGenerator.shared.makeJWT()
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
    case failToRequestToken
    case failToRevokeAppleID
  }
}

