//
//  UserDefaultsClient.swift
//  Services
//
//  Created by YangJoonHyeok on 6/8/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import ComposableArchitecture
import Foundation

public struct UserDefaultsClient {
  public var string: @Sendable (_ forKey: String) -> String?
  public var integer: @Sendable (_ forKey: String) -> Int?
  public var bool: @Sendable (_ forKey: String) -> Bool?
  public var float: @Sendable (_ forKey: String) -> Float?
  public var double: @Sendable (_ forKey: String) -> Double?
  public var data: @Sendable (_ forKey: String) -> Data?
  public var object: @Sendable (_ forKey: String) -> Any?
  public var set: @Sendable (_ value: Any, _ forKey: String) -> Void
  public var removeObject: @Sendable (_ forKey: String) -> Void
}

extension UserDefaultsClient: DependencyKey {
  static func getValue<T>(_ type: T.Type, forKey key: String) -> T? {
      let value = UserDefaults.standard.object(forKey: key) as? T
      return value
  }
  
  public static var liveValue: UserDefaultsClient {
    return Self(
      string: { key in
        return getValue(String.self, forKey: key)
      },
      integer: { key in
        return getValue(Int.self, forKey: key)
      },
      bool: { key in
        return getValue(Bool.self, forKey: key)
      },
      float: { key in
        return getValue(Float.self, forKey: key)
      },
      double: { key in
        return getValue(Double.self, forKey: key)
      },
      data: { key in
        return getValue(Data.self, forKey: key)
      },
      object: { key in
        return UserDefaults.standard.object(forKey: key)
      },
      set: { value, key in
        UserDefaults.standard.set(value, forKey: key)
      },
      removeObject: { key in
        UserDefaults.standard.removeObject(forKey: key)
      }
    )
  }
  
  public static var testValue: UserDefaultsClient {
    return UserDefaultsClient(
      string: unimplemented("\(Self.self).string"),
      integer: unimplemented("\(Self.self).integer"),
      bool: unimplemented("\(Self.self).bool"),
      float: unimplemented("\(Self.self).float"),
      double: unimplemented("\(Self.self).double"),
      data: unimplemented("\(Self.self).data"),
      object: unimplemented("\(Self.self).object"),
      set: unimplemented("\(Self.self).set"),
      removeObject: unimplemented("\(Self.self).removeObject")
    )
  }
}

public extension DependencyValues {
  var userDefaultsClient: UserDefaultsClient {
    get { self[UserDefaultsClient.self] }
    set { self[UserDefaultsClient.self] = newValue }
  }
}
