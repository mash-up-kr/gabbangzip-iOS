//
//  UIPasteBoardClient.swift
//  Services
//
//  Created by YangJoonHyeok on 8/1/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import ComposableArchitecture
import UIKit

@DependencyClient
public struct UIPasteBoardClient: Sendable {
  public var copyTextToClipboard: @Sendable (String) -> Void
}

extension UIPasteBoardClient: DependencyKey {
  public static var liveValue: UIPasteBoardClient {
    return UIPasteBoardClient(
      copyTextToClipboard: { text in
        UIPasteboard.general.string = text
      }
    )
  }
  
  public static var testValue: UIPasteBoardClient {
    return UIPasteBoardClient()
  }
}

extension DependencyValues {
  public var uiPasteBoardClient: UIPasteBoardClient {
    get { self[UIPasteBoardClient.self] }
    set { self[UIPasteBoardClient.self] = newValue }
  }
}
