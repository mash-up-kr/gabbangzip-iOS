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
    public var alarmStatus: Status
    public var nickname: String
    public var currentVersion: String
    public var isLogoutPresented: Bool
    public var isWithdrawPresented: Bool
    public var isLoginViewPresented: Bool
    public var isSettingErrorPresented: Bool
    public var isLogoutErrorPresented: Bool
    public var isWithdrawErrorPresented: Bool
    
    public enum Status: String {
      case on
      case off
    }
    
    public init(
      alarmStatus: Status,
      nickname: String,
      currentVersion: String,
      isLogoutPresented: Bool = false,
      isWithdrawPresented: Bool = false,
      isLoginViewPresented: Bool = false,
      isSettingErrorPresented: Bool = false,
      isLogoutErrorPresented: Bool = false,
      isWithdrawErrorPresented: Bool = false
    ) {
      self.alarmStatus = alarmStatus
      self.nickname = nickname
      self.currentVersion = currentVersion
      self.isLogoutPresented = isLogoutPresented
      self.isWithdrawPresented = isWithdrawPresented
      self.isLoginViewPresented = isLoginViewPresented
      self.isSettingErrorPresented = isSettingErrorPresented
      self.isLogoutErrorPresented = isLogoutErrorPresented
      self.isWithdrawErrorPresented = isWithdrawErrorPresented
    }
  }
  
  public enum Action: BindableAction {
    case checkPushOn
    case updatePushStatus(Bool)
    case openSetting
    case logError(MyPageCoreError)
    case showLogout(Bool)
    case logout
    case showWithdraw(Bool)
    case withdraw
    case getAccessTokenToDelete
    case deleteUser(String)
    case deleteUserInfo
    case binding(BindingAction<State>)
    case showLoginView
    case showSettingError(Bool)
    case showLogoutError(Bool)
    case showWithdrawError(Bool)
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
            let isPushOn = try await unUserNotificationCenterClient.isPushEnable()
            await send(.updatePushStatus(isPushOn))
          } catch {
            await send(.logError(MyPageCoreError(code: .alarmStatusError)))
          }
        }
        
      case let .updatePushStatus(pushStatus):
        state.alarmStatus = pushStatus ? .on : .off
        return .none
        
      case .openSetting:
        return .run { send in
          do {
            let isSettingOpened = try await uiApplicationClient.openSetting()
            if !isSettingOpened {
              await send(.showSettingError(true))
            }
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
          await send(.deleteUserInfo)
          await send(.showLoginView)
        } catch: { error, send in
          await send(.logError(MyPageCoreError(code: .failToLogout)))
          await send(.showLogoutError(true))
        }
        
      case let .showWithdraw(isPresented):
        state.isWithdrawPresented = isPresented
        return .none
        
      case .withdraw:
        return .run { send in
          try await kakaoLoginClient.logout()
          await send(.getAccessTokenToDelete)
          await send(.deleteUserInfo)
          await send(.showLoginView)
        } catch: { error, send in
          await send(.logError(MyPageCoreError(code: .failToWithdraw)))
          await send(.showWithdrawError(true))
        }
        
      case .getAccessTokenToDelete:
        return .run { send in
          let user = try await keyChainClient.read(.accessToken)
          
          await send(.deleteUser(user))
        } catch: { error, send in
          await send(.logError(MyPageCoreError(code: .failToGetAccessToken)))
        }
        
      case let .deleteUser(accessToken):
        return .run { send in
          let deleteUserInfo = try await kakaoAPIClient.delete(accessToken)
          
          if deleteUserInfo == nil {
            await send(.logError(MyPageCoreError(code: .failToGetDeleteUserInfo)))
          }
        } catch: { error, send in
          await send(.logError(MyPageCoreError(code: .failToDeleteUser)))
        }
        
      case .deleteUserInfo:
        return .run { send in
          try await keyChainClient.delete(.accessToken)
          try await keyChainClient.delete(.refreshToken)
          userDefaultsClient.removeObject(.nickname)
        } catch: { error, send in
          await send(.logError(MyPageCoreError(code: .failToDeleteUserInfo)))
        }
        
      case .binding:
        return .none
        
      case .showLoginView:
        state.isLoginViewPresented = true
        return .none
        
      case let .showSettingError(isSettingErrorPresented):
        state.isSettingErrorPresented = isSettingErrorPresented
        return .none
        
      case let .showLogoutError(isLogoutErrorPresented):
        state.isLogoutErrorPresented = isLogoutErrorPresented
        return .none
        
      case let .showWithdrawError(isWithdrawErrorPresented):
        state.isWithdrawErrorPresented = isWithdrawErrorPresented
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
    case failToDeleteUserInfo
    case failToWithdraw
  }
}
