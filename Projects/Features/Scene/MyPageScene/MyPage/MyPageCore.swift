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
    public var isNextPage: Bool
    
    public init(
      alarmStatus: String,
      nickname: String,
      isLogoutPresented: Bool = false,
      isUnregisterPresented: Bool = false,
      isNextPage: Bool = false
    ) {
      self.alarmStatus = alarmStatus
      self.nickname = nickname
      self.isLogoutPresented = isLogoutPresented
      self.isUnregisterPresented = isUnregisterPresented
      self.isNextPage = isNextPage
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
    case getAccessToken
    case deleteUser(String)
    case binding(BindingAction<State>)
    case showNext
  }
  
  @Dependency(\.userDefaultsClient) private var userDefaultsClient
  @Dependency(\.unUserNotificationCenterClient) private var unUserNotificationCenterClient
  @Dependency(\.uiApplicationClient) private var uiApplicationClient
  @Dependency(\.kakaoAPIClient) private var kakaoAPIClient
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
          try await kakaoLoginClient.logout()
          try await keyChainClient.delete(key: .accessToken)
          try await keyChainClient.delete(key: .refreshToken)
          userDefaultsClient.removeObject(forKey: .nickname)
          await send(.showNext)
        } catch: { error, send in
          await send(.logError(MyPageCoreError(code: .failToLogout)))
        }
        
      case let .showUnregister(isPresented):
        state.isUnregisterPresented = isPresented
        return .none
        
      case .unregister:
        return .run { send in
          await send(.logout)
          await send(.getAccessToken)
          try await keyChainClient.delete(key: .accessToken)
          try await keyChainClient.delete(key: .refreshToken)
          userDefaultsClient.removeObject(forKey: .nickname)
          await send(.showNext)
        } catch: { error, send in
          await send(.logError(MyPageCoreError(code: .failToUnregister)))
        }
        
      case .getAccessToken:
        return .run { send in
          let user = try await keyChainClient.read(key: .accessToken)
          
          await send(.deleteUser(user))
        } catch: { error, send in
          await send(.logError(MyPageCoreError(code: .failToGetAccessToken)))
        }
        
      case let .deleteUser(accessToken):
        return .run { send in
          let deleteUserInfo = try await kakaoAPIClient.delete(accessToken: accessToken)
          
          if deleteUserInfo == nil {
            await send(.logError(MyPageCoreError(code: .failToGetDeleteUserInfo)))
          }
        } catch: { error, send in
          await send(.logError(MyPageCoreError(code: .failToDeleteUser)))
        }
        
      case .binding:
        return .none
        
      case .showNext:
        state.isNextPage = true
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
    case failToGetAccessToken
    case failToGetDeleteUserInfo
    case failToDeleteUser
    case failToUnregister
  }
}
