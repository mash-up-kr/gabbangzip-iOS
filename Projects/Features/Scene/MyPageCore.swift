//
//  MyPageCore.swift
//  MyPage
//
//  Created by Hyun A Song on 7/5/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import ComposableArchitecture
import Services
import UIKit

@Reducer
public struct MyPageCore {
  public init() {}
  
  @ObservableState
  public struct State: Equatable {
    public let myPageTitle = "마이페이지"
    public let alarmSetting = "알림 설정"
    public let appAlarm = "앱 알람 설정"
    public var alarmStatus: String
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
  
  public enum Action {
    case checkPushOn
  }
  
  @Dependency(\.userDefaultsClient) private var userDefaultsClient
  
  public var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .checkPushOn:
        let isPushOn = UIApplication.shared.isRegisteredForRemoteNotifications
        
        if isPushOn {
          state.alarmStatus = "on"
        } else {
          state.alarmStatus = "off"
        }
        return .none
      }
    }
  }
}
