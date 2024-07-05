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
  public var isPushOn: @MainActor @Sendable () async throws -> Bool
}

extension UNUserNotificationCenterClient: DependencyKey {
  public static var liveValue: UNUserNotificationCenterClient {
    return UNUserNotificationCenterClient(
      isPushOn: {
        try await withCheckedThrowingContinuation { continuation in
          UNUserNotificationCenter.current().requestAuthorization { status, error in
            if error != nil {
              continuation.resume(throwing: UNUserNotificationCenterClientError(code: .unUserNotificationCenterError))
            } else if status {
              continuation.resume(returning: true)
            } else {
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
