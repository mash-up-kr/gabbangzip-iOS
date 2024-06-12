//
//  PhotoClient.swift
//  Services
//
//  Created by GREEN on 6/12/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import ComposableArchitecture
import Photos
import SwiftUI

// MARK: - API Client Interface
@DependencyClient
public struct PhotoClient {
  public var checkPhotoLibraryAuthorization: @Sendable () async throws -> Result<Bool, Error>
  public var requestPhotoLibraryAccess: @Sendable () async throws -> Result<Bool, Error>
}

// MARK: - API Client Implementation
extension PhotoClient: DependencyKey {
  public static let liveValue = PhotoClient(
    checkPhotoLibraryAuthorization: {
      let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
      return try await handleStatus(status)
    },
    requestPhotoLibraryAccess: {
      let status = await PHPhotoLibrary.requestAuthorization(for: .readWrite)
      return try await handleStatus(status)
    }
  )
  
  public static let testValue = PhotoClient(
    checkPhotoLibraryAuthorization: unimplemented("\(Self.self).checkPhotoLibraryAuthorization"),
    requestPhotoLibraryAccess: unimplemented("\(Self.self).requestPhotoLibraryAccess")
  )
  
  private static func handleStatus(_ status: PHAuthorizationStatus) async throws -> Result<Bool, Error> {
    switch status {
    case .authorized, .limited:
      return .success(true)
    default:
      return .failure(PhotoClientError(code: .notAccessPhotoLibrary))
    }
  }
}

public extension DependencyValues {
  var photoClient: PhotoClient {
    get { self[PhotoClient.self] }
    set { self[PhotoClient.self] = newValue }
  }
}

// MARK: - PhotoClient Error
public struct PhotoClientError: GabbangzipError {
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
    case notAccessPhotoLibrary = 0
  }
}
