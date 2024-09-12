//
//  UserDefaultsClient.swift
//  Services
//
//  Created by YangJoonHyeok on 6/8/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import ComposableArchitecture
import Foundation

@DependencyClient
public struct UserDefaultsClient: Sendable {
  public var string: @Sendable (_ forKey: Key) throws -> String
  public var integer: @Sendable (_ forKey: Key) throws -> Int
  public var bool: @Sendable (_ forKey: Key) throws -> Bool
  public var float: @Sendable (_ forKey: Key) throws -> Float
  public var double: @Sendable (_ forKey: Key) throws -> Double
  public var data: @Sendable (_ forKey: Key) throws -> Data
  public var object: @Sendable (_ forKey: Key) throws -> Any
  public var set: @Sendable (_ forKey: Key, _ value: Any) -> Void
  public var removeObject: @Sendable (_ forKey: Key) -> Void
}

extension UserDefaultsClient: DependencyKey {
  static func getValue<T>(_ type: T.Type, forKey key: Key) throws -> T {
    guard let value = UserDefaults.standard.object(forKey: key.rawValue) else {
      throw UserDefaultsClientError(code: .keyNotFound)
    }
    guard let typeCastedValue = value as? T else {
      throw UserDefaultsClientError(code: .typeMismatch)
    }
    return typeCastedValue
  }
  
  public static var liveValue: UserDefaultsClient {
    return Self(
      string: { key in
        return try getValue(String.self, forKey: key)
      },
      integer: { key in
        return try getValue(Int.self, forKey: key)
      },
      bool: { key in
        return try getValue(Bool.self, forKey: key)
      },
      float: { key in
        return try getValue(Float.self, forKey: key)
      },
      double: { key in
        return try getValue(Double.self, forKey: key)
      },
      data: { key in
        return try getValue(Data.self, forKey: key)
      },
      object: { key in
        guard let object = UserDefaults.standard.object(forKey: key.rawValue) else {
          throw UserDefaultsClientError(code: .keyNotFound)
        }
        return object
      },
      set: { key, value in
        UserDefaults.standard.set(value, forKey: key.rawValue)
      },
      removeObject: { key in
        UserDefaults.standard.removeObject(forKey: key.rawValue)
      }
    )
  }
  
  public static var testValue: UserDefaultsClient {
    return UserDefaultsClient()
  }
}

public extension DependencyValues {
  var userDefaultsClient: UserDefaultsClient {
    get { self[UserDefaultsClient.self] }
    set { self[UserDefaultsClient.self] = newValue }
  }
}

// MARK: - Keys NameSpace
extension UserDefaultsClient {
  public enum Key: String {
    case nickname
    case isFirstVoteDone
  }
}

// MARK: - Snapshot Error
public struct UserDefaultsClientError: GabbangzipError {
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
    case keyNotFound
    case typeMismatch
  }
}
