//
//  MyPageCore.swift
//  MyPage
//
//  Created by Hyun A Song on 7/5/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import Common
import ComposableArchitecture
import Services

@Reducer
public struct MyPageCore {
  public init() {}
  
  @ObservableState
  public struct State: Equatable {
    public let myPageTitle = "마이페이지"
    public let alarmSetting = "알림 설정"
    public let appAlarm = "앱 알람 설정"
    public var alarmStatus = "unknown"
    public let userSetting = "계정 설정"
    public let version = "현재 버전"
    public let currentVersion = "1.0.0"
    public let logout = "로그아웃"
    public let unregister = "회원탈퇴"
    public var nickname: String
    
    public init(alarmStatus: String, nickname: String) {
      self.alarmStatus = alarmStatus
      self.nickname = nickname
    }
  }
  
  public enum Action: BindableAction {
    case checkPushOn
    case updatePushStatus(Bool)
    case binding(BindingAction<State>)
    case openSetting
    case logError(MyPageCoreError)
  }
  
  @Dependency(\.userDefaultsClient) private var userDefaultsClient
  @Dependency(\.unUserNotificationCenterClient) private var unUserNotificationCenterClient
  @Dependency(\.uiApplicationClient) private var uiApplicationClient
  
  public var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .checkPushOn:
        return .run { send in
          do {
            let isPushOn = try await unUserNotificationCenterClient.isPushOn()
            await send(.updatePushStatus(isPushOn))
          } catch {
            await send(.logError(MyPageCoreError(code: .alarmStatusError)))
          }
        }
        
      case let .updatePushStatus(pushStatus):
        state.alarmStatus = pushStatus ? "on" : "off"
        return .none
        
      case .binding:
        return .none
        
      case .openSetting:
        return .run { send in
          do {
            try await uiApplicationClient.openURL()
          } catch {
            await send(.logError(MyPageCoreError(code: .failToGetOpenUrl)))
          }
        }
        
      case let .logError(error):
        logger.error("MyPage Error \(error)")
        return .none
      }
    }
  }
}

// MARK: - MyPageCoreError
public struct MyPageCoreError: GabbangzipError {
  public var userInfo: [String: Any] = [:]
  public var code: Code
  public var underlying: Error?
  
  public enum Code: Int {
    case alarmStatusError
    case failToGetOpenUrl
  }
}
