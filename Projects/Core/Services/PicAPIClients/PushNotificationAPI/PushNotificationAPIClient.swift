//
//  PushNotificationAPIClient.swift
//  Services
//
//  Created by YangJoonHyeok on 8/8/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import ComposableArchitecture
import Get
import Models

@DependencyClient
public struct PushNotificationAPIClient: Sendable {
  public var registerFCMToken: (_ accessToken: String, _ fcmToken: String) async throws -> RegisteredFCMToken
  public var kook: (_ accessToken: String, _ eventID: Int) async throws -> KookInfo
}

extension PushNotificationAPIClient: DependencyKey {
  public static var liveValue: PushNotificationAPIClient {
    return PushNotificationAPIClient(
      registerFCMToken: { accessToken, fcmToken in
        let route = PushNotificationAPI.registerFCMToken(accessToken: accessToken, fcmToken: fcmToken)
        let request = Request<SuccessResponse<RegisteredFCMToken>>(route: route)
        
        do {
          let response = try await NetworkManager.shared.send(request)
          return response.value.data
        } catch {
          throw PushNotificationAPIClientError(
            code: .getAPIError,
            underlying: error
          )
        }
      },
      kook: { accessToken, eventID in
        let route = PushNotificationAPI.kook(accessToken: accessToken, eventID: eventID)
        let request = Request<SuccessResponse<KookInfo>>(route: route)
        
        do {
          let response = try await NetworkManager.shared.send(request)
          return response.value.data
        } catch {
          throw PushNotificationAPIClientError(
            code: .getAPIError,
            underlying: error
          )
        }
      }
    )
  }
  
  public static var testValue: PushNotificationAPIClient {
    return PushNotificationAPIClient()
  }
  
  public static var previewValue: PushNotificationAPIClient {
    return PushNotificationAPIClient(
      registerFCMToken: { _, _ in
        return RegisteredFCMToken.mock
      },
      kook: { _, _ in
        return KookInfo.mock
      }
    )
  }
}

extension DependencyValues {
  public var pushNotificationAPIClient: PushNotificationAPIClient {
    get { self[PushNotificationAPIClient.self] }
    set { self[PushNotificationAPIClient.self] = newValue }
  }
}

public struct PushNotificationAPIClientError: GabbangzipError {
  public var userInfo: [String: Any]
  public var code: APIResponseError
  public var underlying: Error?

  public init(
    userInfo: [String: Any] = [:],
    code: APIResponseError,
    underlying: Error? = nil
  ) {
    self.userInfo = userInfo
    self.code = code
    self.underlying = underlying
  }

  public enum APIResponseError: Int {
    case getAPIError
  }
}
