//
//  KeyChainClient.swift
//  Services
//
//  Created by Hyun A Song on 6/22/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import ComposableArchitecture
import Foundation
import Models

@DependencyClient
public struct KeyChainClient: Sendable {
  public var createUserInfo: @Sendable (_ userInfo: UserInfo) async throws -> Void
  public var readUserInfo: @Sendable () async throws -> UserInfo
  public var updateUserInfo: @Sendable (_ userInfo: UserInfo) async throws -> Void
  public var deleteUserInfo: @Sendable () async throws -> Void
  public var createRefreshToken: @Sendable (_ refreshToken: String) async throws -> Void
  public var readRefreshToken: @Sendable () async throws -> String
  public var deleteRefreshToken: @Sendable () async throws -> Void
  public var createAppVersion: @Sendable (_ appVersion: String) async throws -> Void
  public var readAppVersion: @Sendable () async throws -> String
  public var updateAppVersion: @Sendable (_ appVersion: String) async throws -> Void
}

extension KeyChainClient: DependencyKey {
  public static var liveValue: KeyChainClient {
    return .init(
      createUserInfo: { userInfo in
        guard let encodedData = try? JSONEncoder().encode(userInfo) else {
          throw KeyChainClientError(code: .failToEncode)
        }
        
        try create(.userInfo, encodedData)
      },
      readUserInfo: {
        let query: NSDictionary = [
          kSecClass: kSecClassGenericPassword,
          kSecAttrAccount: Key.userInfo.rawValue,
          kSecReturnData: kCFBooleanTrue as Any,
          kSecMatchLimit: kSecMatchLimitOne
        ]
        var dataTypeReference: AnyObject?
        let status = SecItemCopyMatching(query, &dataTypeReference)
        
        switch status {
        case errSecSuccess:
          if let retrieveData = dataTypeReference as? Data,
             let decodedData = try? JSONDecoder().decode(UserInfo.self, from: retrieveData) {
            return decodedData
          } else {
            throw KeyChainClientError(code: .failToGetData)
          }
        default:
          throw KeyChainClientError(code: .failToRead)
        }
      },
      updateUserInfo: { userInfo in
        guard let encodedData = try? JSONEncoder().encode(userInfo) else {
          throw KeyChainClientError(code: .failToEncode)
        }
        
        try update(.userInfo, encodedData)
      },
      deleteUserInfo: {
        try delete(.userInfo)
      },
      createRefreshToken: { refreshToken in
        guard let encodedData = try? JSONEncoder().encode(refreshToken) else {
          throw KeyChainClientError(code: .failToEncode)
        }
        
        try create(.refreshToken, encodedData)
      },
      readRefreshToken: {
        let query: NSDictionary = [
          kSecClass: kSecClassGenericPassword,
          kSecAttrAccount: Key.refreshToken.rawValue,
          kSecReturnData: kCFBooleanTrue as Any,
          kSecMatchLimit: kSecMatchLimitOne
        ]
        var dataTypeReference: AnyObject?
        let status = SecItemCopyMatching(query, &dataTypeReference)
        
        switch status {
        case errSecSuccess:
          if let retrieveData = dataTypeReference as? Data,
             let decodedData = try? JSONDecoder().decode(String.self, from: retrieveData) {
            return decodedData
          } else {
            throw KeyChainClientError(code: .failToGetData)
          }
        default:
          throw KeyChainClientError(userInfo: ["status": status], code: .failToRead)
        }
      },
      deleteRefreshToken: {
        try delete(.refreshToken)
      },
      createAppVersion: { appVersion in
        guard let encodedData = try? JSONEncoder().encode(appVersion) else {
          throw KeyChainClientError(code: .failToEncode)
        }
        
        try create(.appVersion, encodedData)
      },
      readAppVersion: {
        let query: NSDictionary = [
          kSecClass: kSecClassGenericPassword,
          kSecAttrAccount: Key.appVersion.rawValue,
          kSecReturnData: kCFBooleanTrue as Any,
          kSecMatchLimit: kSecMatchLimitOne
        ]
        var dataTypeReference: AnyObject?
        let status = SecItemCopyMatching(query, &dataTypeReference)
        
        switch status {
        case errSecSuccess:
          if let retrieveData = dataTypeReference as? Data,
             let decodedData = try? JSONDecoder().decode(String.self, from: retrieveData) {
            return decodedData
          } else {
            throw KeyChainClientError(code: .failToGetData)
          }
        default:
          throw KeyChainClientError(userInfo: ["status": status], code: .failToRead)
        }
      },
      updateAppVersion: { appVersion in
        guard let encodedData = try? JSONEncoder().encode(appVersion) else {
          throw KeyChainClientError(code: .failToEncode)
        }
        
        try update(.appVersion, encodedData)
      }
    )
  }
}

extension KeyChainClient {
  private static func create(_ key: Key, _ data: Data) throws {
    let query: NSDictionary = [
      kSecClass: kSecClassGenericPassword,
      kSecAttrAccount: key.rawValue,
      kSecValueData: data
    ]
    let status = SecItemAdd(query, nil)
    
    switch status {
    case errSecSuccess:
      break
    case errSecDuplicateItem:
      try update(key, data)
    default:
      throw KeyChainClientError(code: .failToCreate)
    }
  }
  
  private static func update(_ key: Key, _ data: Data) throws {
    let previousQuery: NSDictionary = [
      kSecClass: kSecClassGenericPassword,
      kSecAttrAccount: key.rawValue,
    ]
    let updateQuery: NSDictionary = [
      kSecValueData: data
    ]
    let status = SecItemUpdate(previousQuery, updateQuery)
    
    switch status {
    case errSecSuccess:
      break
    default:
      throw KeyChainClientError(code: .failToUpdate)
    }
  }
  
  private static func delete(_ key: Key) throws {
    let query: NSDictionary = [
      kSecClass: kSecClassGenericPassword,
      kSecAttrAccount: key.rawValue
    ]
    
    let status = SecItemDelete(query)
    
    switch status {
    case errSecNoSuchKeychain:
      throw KeyChainClientError(code: .failToDelete)
    case errSecItemNotFound:
      throw KeyChainClientError(code: .failToDelete)
    case noErr:
      break
    default:
      throw KeyChainClientError(code: .failToDelete)
    }
  }
}

// MARK: - Keys NameSpace
extension KeyChainClient {
  public enum Key: String {
    case userInfo
    case refreshToken
    case appVersion
  }
}

extension DependencyValues {
  public var keyChainClient: KeyChainClient {
    get { self[KeyChainClient.self] }
    set { self[KeyChainClient.self] = newValue }
  }
}

// MARK: - KeyChainClientError
public struct KeyChainClientError: GabbangzipError {
  public var userInfo: [String: Any] = [:]
  public var code: Code
  public var underlying: Error?
  
  public enum Code: Int {
    case failToCreate
    case failToGetData
    case failToRead
    case failToUpdate
    case failToDelete
    case failToEncode
    case failToDecode
  }
}
