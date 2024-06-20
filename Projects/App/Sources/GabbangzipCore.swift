//
//  GabbangzipCore.swift
//  App
//
//  Created by Hyun A Song on 6/19/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import ComposableArchitecture
import Foundation
import Services
import KakaoSDKUser

@Reducer
public struct GabbangzipCore {
  public struct State: Equatable {

    public init() {}
  }

  public enum Action {
    case onOpenURL(URL)
  }
  
  @Dependency(\.kakaoLoginClient) var kakaoLoginClient

  public var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case let .onOpenURL(url):
        return .run { send in
          kakaoLoginClient.openURL(url: url)
        }
      }
    }
  }
}