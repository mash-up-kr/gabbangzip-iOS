//
//  FirebaseClient.swift
//  Services
//
//  Created by Hyun A Song on 7/19/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import ComposableArchitecture
import Firebase
import FirebaseMessaging

@DependencyClient
public struct FirebaseClient: Sendable {
  public var configure: @Sendable () -> Void
  public var verifyInstallations: @Sendable () async throws -> String
  public var verifyMessaging: @Sendable () async throws -> String
  public var getDeviceToken: @Sendable (Data) -> Void
}

extension FirebaseClient: DependencyKey {
  public static var liveValue: FirebaseClient {
    return FirebaseClient(
      configure: {
        FirebaseApp.configure()
      },
      verifyInstallations: {
        let result = try await Installations.installations().authTokenForcingRefresh(true)
        
        return result.authToken
      },
      verifyMessaging: {
        try await withCheckedThrowingContinuation { continuation in
          Messaging.messaging().token { token, error in
            if let error = error {
              continuation.resume(throwing: FirebaseClientError(code: .failToGetMessaging))
            } else if let token = token {
              continuation.resume(returning: token)
            }
          }
        }
      },
      getDeviceToken: { data in
        Messaging.messaging().apnsToken = data
      }
    )
  }
  
  public static var testValue: FirebaseClient {
    return FirebaseClient()
  }
}

public extension DependencyValues {
  var firebaseClient: FirebaseClient {
    get { self[FirebaseClient.self] }
    set { self[FirebaseClient.self] = newValue }
  }
}

// MARK: - FirebaseClientError
public struct FirebaseClientError: GabbangzipError {
  public var userInfo: [String: Any]
  public var code: Code
  public var underlying: Error?
  
  public init(
    userInfo: [String: Any] = [:],
    code: Code,
    underlying: Error? = nil
  ) {
    self.userInfo = userInfo
    self.code = code
    self.underlying = underlying
  }
  
  public enum Code: Int {
    case failToGetMessaging
  }
}
