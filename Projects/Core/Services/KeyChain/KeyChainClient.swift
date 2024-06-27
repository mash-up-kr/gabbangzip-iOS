//
//  KeyChainClient.swift
//  Services
//
//  Created by Hyun A Song on 6/22/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import ComposableArchitecture
import Foundation

@DependencyClient
public struct KeyChainClient {
  public var create: @Sendable (_ key: Key, _ data: String) async throws -> Void
  public var read: @Sendable (_ key: Key) async -> Result<String?, KeyChainClientError> = { key in .failure(.init(code: .failToRead)) }
  public var update: @Sendable (_ key: Key, _ data: String) async throws -> Void
  public var delete: @Sendable (_ key: Key) async throws -> Void
}

extension KeyChainClient: DependencyKey {
  public static var liveValue: KeyChainClient {
    return .init(
      create: { key, data in
        let query: NSDictionary = [
          kSecClass: kSecClassGenericPassword,
          kSecAttrAccount: key.type,
          kSecValueData: data.data(using: .utf8) as Any
        ]
        let status = SecItemAdd(query, nil)
        
        switch status {
        case errSecSuccess:
          break
        case errSecDuplicateItem:
          try updateKey(key, data)
        default:
          throw KeyChainClientError(code: .failToCreate)
        }
      },
      read: { key in
        let query: NSDictionary = [
          kSecClass: kSecClassGenericPassword,
          kSecAttrAccount: key.type,
          kSecReturnData: kCFBooleanTrue as Any,
          kSecMatchLimit: kSecMatchLimitOne
        ]
        var dataTypeReference: AnyObject?
        let status = SecItemCopyMatching(query, &dataTypeReference)
        
        switch status {
        case errSecSuccess:
          if let retrieveData = dataTypeReference as? Data {
            let value = String(
              data: retrieveData,
              encoding: String.Encoding.utf8
            )
            return .success(value)
          } else {
            return .failure(KeyChainClientError(code: .failToGetData)) 
          }
        default:
            return .failure(KeyChainClientError(code: .failToRead))
        }
      },
      update: { key, data in
        try updateKey(key, data)
      },
      delete: { key in
        let query: NSDictionary = [
          kSecClass: kSecClassGenericPassword,
          kSecAttrAccount: key.rawValue
        ]
        
        let status = SecItemDelete(query)
        
        switch status {
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
  private static func updateKey(_ key: Key, _ data: String) throws {
    let previousQuery: NSDictionary = [
      kSecClass: kSecClassGenericPassword,
      kSecAttrAccount: key.type,
    ]
    let updateQuery: NSDictionary = [
      kSecValueData: data.data(using: .utf8) as Any
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
    case accessToken
    case refreshToken
    
    var type: String {
      switch self {
      case .accessToken:
        return "accessToken"
      case .refreshToken:
        return "refreshToken"
      }
    }
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
    case failToRead
    case failToUpdate
    case failToDelete
    case failToGetData
  }
}
