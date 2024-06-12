//
//  HapticClient.swift
//  Services
//
//  Created by GREEN on 6/8/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

// MARK: - API Client Interface
public struct HapticClient {
  /// 사용자 인터랙션에 따른 햅틱 반응 (light || medium || heavy || soft || rigid)
  public var triggerImpact: @Sendable (UIImpactFeedbackGenerator.FeedbackStyle) async -> Void
  /// 작업 완료 여부에 따른 햅틱 반응 (success || warning || error)
  public var triggerNotification: @Sendable (UINotificationFeedbackGenerator.FeedbackType) async -> Void
}

// MARK: - API Client Implementation
extension HapticClient: DependencyKey {
  public static let liveValue = HapticClient(
    triggerImpact: { style in
      let generator = await UIImpactFeedbackGenerator(style: style)
      await generator.impactOccurred()
    },
    triggerNotification: { type in
      let generator = await UINotificationFeedbackGenerator()
      await generator.notificationOccurred(type)
    }
  )
  
  public static let testValue = HapticClient(
    triggerImpact: unimplemented("\(Self.self).triggerImpact"),
    triggerNotification: unimplemented("\(Self.self).triggerNotification")
  )
}

public extension DependencyValues {
  var hapticClient: HapticClient {
    get { self[HapticClient.self] }
    set { self[HapticClient.self] = newValue }
  }
}
