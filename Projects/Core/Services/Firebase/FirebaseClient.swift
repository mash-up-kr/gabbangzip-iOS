//
//  FirebaseClient.swift
//  Services
//
//  Created by Hyun A Song on 7/19/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import ComposableArchitecture
import Firebase

@DependencyClient
public struct FirebaseClient: Sendable {
  public var configure: @Sendable () async -> Void
  public var runAutoInitialization: @Sendable () async -> Void
  public var setDeviceToken: @Sendable (Data) async -> Void
  public var checkRegistrationToken: @Sendable () async throws -> String
}

extension FirebaseClient: DependencyKey {
  public static var liveValue: FirebaseClient {
    return FirebaseClient(
      configure: { @MainActor in
        FirebaseApp.configure()
      },
      runAutoInitialization: {
        Messaging.messaging().isAutoInitEnabled = true
      },
      setDeviceToken: { data in
        Messaging.messaging().apnsToken = data
      },
      checkRegistrationToken: {
        try await withCheckedThrowingContinuation { continuation in
          Messaging.messaging().token { token, error in
            if let error = error {
              continuation.resume(throwing: FirebaseClientError(code: .failToGetMessaging, underlying: error))
            } else if let token {
              continuation.resume(returning: token)
            } else {
              continuation.resume(throwing: FirebaseClientError(code: .unknownError))
            }
          }
        }
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
    case unknownError
  }
}
