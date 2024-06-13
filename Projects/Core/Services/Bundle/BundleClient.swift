//
//  BundleClient.swift
//  Services
//
//  Created by YangJoonHyeok on 6/8/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import ComposableArchitecture
import Foundation

@DependencyClient
public struct BundleClient {
  public var getValue: @Sendable (_ key: String) throws -> Any
}

extension BundleClient: DependencyKey {
  public static var liveValue: BundleClient {
    return .init(
      getValue: { key in
        guard let value = Bundle.main.object(forInfoDictionaryKey: key) else {
          throw BundleClientError(code: .noValueForKey)
        }
        return value
      }
    )
  }
  
  public static var testValue: BundleClient {
    return BundleClient()
  }
}

public extension DependencyValues {
  var bundleClient: BundleClient {
    get { self[BundleClient.self] }
    set { self[BundleClient.self] = newValue }
  }
}

public struct BundleClientError: GabbangzipError {
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
    case noValueForKey
  }
}
