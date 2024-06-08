//
//  BundleClient.swift
//  Services
//
//  Created by YangJoonHyeok on 6/8/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import ComposableArchitecture
import Foundation

public struct BundleClient {
  public var getValue: @Sendable (_ key: String) -> Any?
}

extension BundleClient: DependencyKey {
  public static var liveValue: BundleClient {
    return .init(
      getValue: { key in
        let value = Bundle.main.object(forInfoDictionaryKey: key)
        return value
      }
    )
  }
  
  public static var testValue: BundleClient {
    return BundleClient(
      getValue: unimplemented("\(Self.self).getValue")
    )
  }
}

public extension DependencyValues {
  var bundleClient: BundleClient {
    get { self[BundleClient.self] }
    set { self[BundleClient.self] = newValue }
  }
}
