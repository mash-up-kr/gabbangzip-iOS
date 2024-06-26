//
//  SnapshotClient.swift
//  Services
//
//  Created by GREEN on 6/5/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

// MARK: - API Client Interface
@DependencyClient
public struct SnapshotClient {
  public var takeSnapshot: @Sendable () async throws -> UIImage
}

// MARK: - API Client Implementation
extension SnapshotClient: DependencyKey {
  public static let liveValue = SnapshotClient(
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
        
        let renderer = UIGraphicsImageRenderer(
          size: currentLayer.frame.size,
          format: UIGraphicsImageRendererFormat.default()
        )
        totalImage = renderer.image { context in
          currentLayer.render(in: context.cgContext)
        }
        
        return totalImage ?? UIImage()
      }
    }
  )
}

extension SnapshotClient: TestDependencyKey {
  public static let testValue = Self()
}

public extension DependencyValues {
  var snapshotClient: SnapshotClient {
    get { self[SnapshotClient.self] }
    set { self[SnapshotClient.self] = newValue }
  }
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
