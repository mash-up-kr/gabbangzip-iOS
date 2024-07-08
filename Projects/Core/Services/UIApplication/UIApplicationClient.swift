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
  public var openSetting: @Sendable () async throws -> Void
}

extension UIApplicationClient: DependencyKey {
  public static var liveValue: UIApplicationClient {
    return UIApplicationClient(
      openSetting: { @MainActor in
        try await withCheckedThrowingContinuation { continuation in
          if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
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
