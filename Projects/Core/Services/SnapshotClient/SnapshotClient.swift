//
//  SnapshotClient.swift
//  CoreKit
//
//  Created by GREEN on 6/5/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

// MARK: - API Client Interface
@DependencyClient
struct SnapshotClient {
  var takeSnapshot: @Sendable () async throws -> UIImage
}

extension DependencyValues {
  var snapshotClient: SnapshotClient {
    self[SnapshotClient.self]
  }
}

// MARK: - API Client Implementation
extension SnapshotClient: DependencyKey {
  static let liveValue = SnapshotClient(
    takeSnapshot: {
      try await MainActor.run {
        var totalImage: UIImage?
        
        let keyWindow = UIApplication.shared.connectedScenes
          .compactMap { $0 as? UIWindowScene }
          .flatMap { $0.windows }
          .first { $0.isKeyWindow }
        guard let currentLayer = keyWindow?.layer else {
          throw SnapshotError(code: .failedToGetKeyWindowLayer)
        }
        
        let currentScale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(currentLayer.frame.size, false, currentScale)
        
        guard let currentContext = UIGraphicsGetCurrentContext() else {
          throw SnapshotError(code: .failedToGetCurrentContext)
        }
        currentLayer.render(in: currentContext)
        
        totalImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return totalImage ?? UIImage()
      }
    }
  )
}

// MARK: - Snapshot Error
public struct SnapshotError: GabbangzipError {
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
    case failedToGetKeyWindowLayer = 0
    case failedToGetCurrentContext = 1
  }
}
