//
//  UNUserNotificationCenterClient.swift
//  Services
//
//  Created by Hyun A Song on 7/5/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import ComposableArchitecture
import UIKit

@DependencyClient
public struct UNUserNotificationCenterClient: Sendable {
  public var requestAuthorization: @MainActor @Sendable () async throws -> Bool
}

extension UNUserNotificationCenterClient: DependencyKey {
  public static var liveValue: UNUserNotificationCenterClient {
    return UNUserNotificationCenterClient(
      requestAuthorization: {
        try await withCheckedThrowingContinuation { continuation in
          UNUserNotificationCenter.current()
            .getNotificationSettings { permission in
              switch permission.authorizationStatus  {
              case .authorized:
                continuation.resume(returning: true)
              case .denied:
                continuation.resume(returning: false)
              case .notDetermined:
                continuation.resume(returning: true)
              case .provisional:
                continuation.resume(returning: false)
              case .ephemeral:
                continuation.resume(returning: true)
              @unknown default:
                continuation.resume(returning: false)
              }
            }
        }
      }
    )
  }
  
  public static var testValue: UNUserNotificationCenterClient {
    return UNUserNotificationCenterClient()
  }
}

extension DependencyValues {
  public var unUserNotificationCenterClient: UNUserNotificationCenterClient {
    get { self[UNUserNotificationCenterClient.self] }
    set { self[UNUserNotificationCenterClient.self] = newValue }
  }
}

// MARK: - UNUserNotificationCenterClientError
public struct UNUserNotificationCenterClientError: GabbangzipError {
  public var userInfo: [String: Any] = [:]
  public var code: Code
  public var underlying: Error?
  
  public enum Code: Int {
    case unUserNotificationCenterError
  }
}
