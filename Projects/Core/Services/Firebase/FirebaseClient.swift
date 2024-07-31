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
  public var delegate: @Sendable () -> AsyncStream<DelegateEvent> = { .finished }
  public var runAutoInitialization: @Sendable () async -> Void
  public var getDeviceToken: @Sendable (Data) async -> Void
  public var checkRegistrationToken: @Sendable () async throws -> String
  
  public enum DelegateEvent {
    case messaging(
      _ messaging: Messaging,
      fcmToken: String?
    )
  }
}

extension FirebaseClient: DependencyKey {
  public static var liveValue: FirebaseClient {
    return FirebaseClient(
      configure: {
        FirebaseApp.configure()
      },
      delegate: {
        AsyncStream { continuation in
          let delegate = MessageDelegate(continuation: continuation)
          Messaging.messaging().delegate = delegate
          continuation.onTermination = { _ in
            _ = delegate
          }
        }
      },
      runAutoInitialization: {
        Messaging.messaging().isAutoInitEnabled = true
      },
      getDeviceToken: { data in
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

extension FirebaseClient {
  final class MessageDelegate: NSObject, MessagingDelegate, Sendable {
    let continuation: AsyncStream<DelegateEvent>.Continuation
    
    init(continuation: AsyncStream<DelegateEvent>.Continuation) {
      self.continuation = continuation
    }
    
    deinit {
      continuation.finish()
    }
    
    func messaging(
      _ messaging: Messaging,
      didReceiveRegistrationToken fcmToken: String?
    ) {
      continuation.yield(.messaging(messaging, fcmToken: fcmToken))
    }
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
