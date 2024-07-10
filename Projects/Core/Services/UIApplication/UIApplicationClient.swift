//
//  UIApplicationClient.swift
//  Services
//
//  Created by Hyun A Song on 7/6/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import ComposableArchitecture
import UIKit

@DependencyClient
public struct UIApplicationClient: Sendable {
  public var getSettingURL: @Sendable () async -> String = { "unknown" }
  public var openURL: @Sendable (_ url: String) async throws -> Bool
}

extension UIApplicationClient: DependencyKey {
  public static var liveValue: UIApplicationClient {
    return UIApplicationClient(
      getSettingURL: {
        return await UIApplication.openSettingsURLString
      },
      openURL: { @MainActor url in
        try await withCheckedThrowingContinuation { continuation in
          if let url = URL(string: url) {
            UIApplication.shared.open(url) { success in
              if success {
                continuation.resume(returning: true)
              } else {
                continuation.resume(returning: false)
              }
            }
          } else {
            continuation.resume(throwing: UIApplicationClientError(code: .failToGetUrl))
          }
        }
      }
    )
  }
  
  public static var testValue: UIApplicationClient {
    return UIApplicationClient()
  }
}

extension DependencyValues {
  public var uiApplicationClient: UIApplicationClient {
    get { self[UIApplicationClient.self] }
    set { self[UIApplicationClient.self] = newValue }
  }
}

// MARK: - UIApplicationClientError
public struct UIApplicationClientError: GabbangzipError {
  public var userInfo: [String: Any] = [:]
  public var code: Code
  public var underlying: Error?
  
  public enum Code: Int {
    case failToGetUrl
  }
}
