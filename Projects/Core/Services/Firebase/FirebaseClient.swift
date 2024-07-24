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
  public var delegate: @Sendable () -> AsyncStream<Any> = { .finished }
  public var verifyToken: @Sendable () async throws -> String
  public var getDeviceToken: @Sendable (Data) -> Void
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
      verifyToken: {
        try await withCheckedThrowingContinuation { continuation in
          Messaging.messaging().token { token, error in
            if let error = error {
              continuation.resume(throwing: FirebaseClientError(code: .failToGetMessaging))
            } else if let token {
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

extension FirebaseClient {
  final class MessageDelegate: NSObject, MessagingDelegate, Sendable {
    let continuation: AsyncStream<Any>.Continuation
    
    init(continuation: AsyncStream<Any>.Continuation) {
      self.continuation = continuation
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
      guard let fcmToken else { return }
      let dataDict: [String: String] = ["token": fcmToken]
      
      NotificationCenter.default.post(
        name: Notification.Name("FCMToken"),
        object: nil,
        userInfo: dataDict
      )
      // TODO: If necessary send token to application server.
      // Note: This callback is fired at each app startup and whenever a new token is generated.
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
  }
}
