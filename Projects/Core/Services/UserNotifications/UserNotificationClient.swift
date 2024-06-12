//
//  UserNotificationClient.swift
//  Service
//
//  Created by YangJoonHyeok on 6/8/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import ComposableArchitecture
import UserNotifications

@DependencyClient
public struct UserNotificationClient {
  public var getAuthorizationStatus: @Sendable () async -> UNAuthorizationStatus = { .notDetermined }
  public var delegate: @Sendable () -> AsyncStream<DelegateEvent> = { .finished }
  public var requestAuthorization: @Sendable () async throws -> Void
  
  public enum DelegateEvent {
    case didReceiveResponse(
      UNNotificationResponse,
      completionHandler: @Sendable () -> Void
    )
    case willPresentNotification(
      UNNotification,
      completionHandler: @Sendable (
        UNNotificationPresentationOptions
      ) -> Void
    )
  }
}

extension UserNotificationClient: DependencyKey {
  public static var liveValue: UserNotificationClient {
    let notificationCenter = UNUserNotificationCenter.current()
    return .init(
      getAuthorizationStatus: {
        let authorizationStatus = await notificationCenter.notificationSettings().authorizationStatus
        return authorizationStatus
      },
      delegate: {
        AsyncStream { continuation in
          let delegate = NotificationCenterDelegate(continuation: continuation)
          UNUserNotificationCenter.current().delegate = delegate
          continuation.onTermination = { _ in
            _ = delegate
          }
        }
      },
      requestAuthorization: {
        try await UNUserNotificationCenter.current().requestAuthorization(options: [[.alert, .badge, .sound]])
      }
    )
  }
  
  public static var testValue: UserNotificationClient {
    return UserNotificationClient()
  }
}

extension UserNotificationClient {
  final class NotificationCenterDelegate: NSObject, UNUserNotificationCenterDelegate, Sendable {
    let continuation: AsyncStream<DelegateEvent>.Continuation
    
    init(continuation: AsyncStream<DelegateEvent>.Continuation) {
      self.continuation = continuation
    }
    
    func userNotificationCenter(
      _ center: UNUserNotificationCenter,
      willPresent notification: UNNotification,
      withCompletionHandler completionHandler: @escaping (
        UNNotificationPresentationOptions
      ) -> Void
    ) {
      continuation.yield(.willPresentNotification(notification, completionHandler: { completionHandler($0) }))
    }
    
    func userNotificationCenter(
      _ center: UNUserNotificationCenter,
      didReceive response: UNNotificationResponse,
      withCompletionHandler completionHandler: @escaping () -> Void
    ) {
      continuation.yield(.didReceiveResponse(response, completionHandler: { completionHandler() }))
    }
  }
}

public extension DependencyValues {
  var userNotificationClient: UserNotificationClient {
    get { self[UserNotificationClient.self] }
    set { self[UserNotificationClient.self] = newValue }
  }
}