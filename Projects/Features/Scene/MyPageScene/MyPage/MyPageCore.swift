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
    public var alarmStatus: String
    public var nickname: String
    public var isLogoutPresented: Bool
    public var isUnregisterPresented: Bool
    
    public init(
      alarmStatus: String,
      nickname: String,
      isLogoutPresented: Bool = false,
      isUnregisterPresented: Bool = false
    ) {
      self.alarmStatus = alarmStatus
      self.nickname = nickname
      self.isLogoutPresented = isLogoutPresented
      self.isUnregisterPresented = isUnregisterPresented
    }
  }
  
  public enum Action: BindableAction {
    case checkPushOn
    case updatePushStatus(Bool)
    case openSetting
    case logError(MyPageCoreError)
    case showLogout(Bool)
    case logout
    case showUnregister(Bool)
    case unregister
    case binding(BindingAction<State>)
  }
  
  @Dependency(\.userDefaultsClient) private var userDefaultsClient
  @Dependency(\.unUserNotificationCenterClient) private var unUserNotificationCenterClient
  @Dependency(\.uiApplicationClient) private var uiApplicationClient
  @Dependency(\.kakaoLoginClient) private var kakaoLoginClient
  @Dependency(\.keyChainClient) private var keyChainClient
  
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
        
      case let .showLogout(isPresented):
        state.isLogoutPresented = isPresented
        return .none
        
      case .logout:
        return .run { send in
          do {
            try await kakaoLoginClient.logout()
          } catch {
            await send(.logError(MyPageCoreError(code: .failToLogout)))
          }
        }
        
      case let .showUnregister(isPresented):
        state.isUnregisterPresented = isPresented
        return .none
        
      case .unregister:
        return .run { send in
          do {
            try await keyChainClient.delete(key: .accessToken)
            try await keyChainClient.delete(key: .refreshToken)
            userDefaultsClient.removeObject(forKey: .nickname)
            await send(.logout)
          }
        } catch: { error, send in
          await send(.logError(MyPageCoreError(code: .failToUnregister)))
        }
        
      case .binding:
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
    case failToLogout
    case failToUnregister
  }
}
