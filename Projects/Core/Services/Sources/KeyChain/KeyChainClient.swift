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
}

extension KeyChainClient: DependencyKey {
  public static var liveValue: KeyChainClient {
    return .init(
      createUserInfo: { userInfo in
        guard let encodedData = try? JSONEncoder().encode(userInfo) else {
          throw KeyChainClientError(code: .failToEncode)
        }
        
        let query: NSDictionary = [
          kSecClass: kSecClassGenericPassword,
          kSecAttrAccount: Key.userInfo.rawValue,
          kSecValueData: encodedData
        ]
        let status = SecItemAdd(query, nil)
        
        switch status {
        case errSecSuccess:
          break
        case errSecDuplicateItem:
          try updateKey(.userInfo, encodedData)
        default:
          throw KeyChainClientError(code: .failToCreate)
        }
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
        
        try updateKey(.userInfo, encodedData)
      },
      deleteUserInfo: {
        let query: NSDictionary = [
          kSecClass: kSecClassGenericPassword,
          kSecAttrAccount: Key.userInfo.rawValue
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
      },
      createRefreshToken: { refreshToken in
        guard let encodedData = try? JSONEncoder().encode(refreshToken) else {
          throw KeyChainClientError(code: .failToEncode)
        }
        
        let query: NSDictionary = [
          kSecClass: kSecClassGenericPassword,
          kSecAttrAccount: Key.refreshToken.rawValue,
          kSecValueData: encodedData
        ]
        let status = SecItemAdd(query, nil)
        
        switch status {
        case errSecSuccess:
          break
        case errSecDuplicateItem:
          try updateKey(.userInfo, encodedData)
        default:
          throw KeyChainClientError(code: .failToCreate)
        }
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
          throw KeyChainClientError(code: .failToRead)
        }
      },
      deleteRefreshToken: {
        let query: NSDictionary = [
          kSecClass: kSecClassGenericPassword,
          kSecAttrAccount: Key.refreshToken.rawValue
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
    )
  }
}

extension KeyChainClient {
  private static func updateKey(_ key: Key, _ data: Data) throws {
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
}

// MARK: - Keys NameSpace
extension KeyChainClient {
  public enum Key: String {
    case userInfo
    case refreshToken
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
