//
//  MyPageCore.swift
//  MyPage
//
//  Created by Hyun A Song on 7/5/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import Common
import ComposableArchitecture
import Models
import Services

@Reducer
public struct MyPageCore {
  public init() {}
  
  @ObservableState
  public struct State: Equatable {
    @Shared public var userInfo: UserInfo
    public var currentVersion: String
    public var alarmStatus: AlarmStatus
    public var errorType: MyPageError?
    public var errorMessage: String
    public var popupType: MyPagePopup?
    public var popupTitle: String
    public var popupDescription: String?
    public var popupLeftButtonTitle: String
    public var popupRightButtonTitle: String
    public var isPopupPresented: Bool
    public var isLoginViewPresented: Bool
    public var isErrorPresented: Bool
    
    public enum AlarmStatus: String {
      case on
      case off
    }
    
    public enum MyPageError {
      case setting
      case withdraw
      
      public var message: String {
        switch self {
        case .setting:
          return "설정앱을 여는데 실패했어요."
        case .withdraw:
          return "회원탈퇴에 실패했어요."
        }
      }
    }
    
    public enum MyPagePopup {
      case logout
      case withdraw
      
      public var title: String {
        switch self {
        case .logout:
          return "로그아웃 하시겠어요?"
        case.withdraw:
          return "탈퇴하실건가요?"
        }
      }
      
      public var description: String? {
        switch self {
        case .logout:
          return nil
        case .withdraw:
          return "탈퇴 시 그룹, 활동 내역이\n삭제되며 복구되지 않습니다."
        }
      }
      
      public var leftButtonTitle: String {
        switch self {
        case .logout, .withdraw:
          return "취소"
        }
      }
      
      public var rightButtonTitle: String {
        switch self {
        case .logout:
          return "로그아웃"
        case .withdraw:
          return "탈퇴하기"
        }
      }
    }
    
    public init(
      userInfo: @autoclosure () -> UserInfo = .defaultValue,
      currentVersion: String = "",
      alarmStatus: AlarmStatus = .off,
      errorType: MyPageError? = nil,
      errorMessage: String = "",
      popupType: MyPagePopup? = nil,
      popupTitle: String = "",
      popupDescription: String? = nil,
      popupLeftButtonTitle: String = "",
      popupRightButtonTitle: String = "",
      isPopupPresented: Bool = false,
      isLoginViewPresented: Bool = false,
      isErrorPresented: Bool = false
    ) {
      self._userInfo = Shared(wrappedValue: userInfo(), .inMemory("userInfo"))
      self.currentVersion = currentVersion
      self.alarmStatus = alarmStatus
      self.errorType = errorType
      self.errorMessage = errorMessage
      self.popupType = popupType
      self.popupTitle = popupTitle
      self.popupDescription = popupDescription
      self.popupLeftButtonTitle = popupLeftButtonTitle
      self.popupRightButtonTitle = popupRightButtonTitle
      self.isPopupPresented = isPopupPresented
      self.isLoginViewPresented = isLoginViewPresented
      self.isErrorPresented = isErrorPresented
    }
  }
  
  public enum Action: BindableAction {
    case binding(BindingAction<State>)
    
    // View Action
    case checkPushStatus
    case checkCurrentVersion
    case showPopup(Bool, State.MyPagePopup?)
    case openSetting
    case logout
    
    // Internal Action
    case updatePushStatus(Bool)
    case updateCurrentVersion(String)
    case showError(Bool, State.MyPageError)
    case withdraw
    case logError(Error)
    case revokeAppleID(Result<String, Error>)
    case withdrawAccount
    case getRefreshToken
    case revokeAppleIDResponse(Result<Void, Error>)
    
    // Route Action
    case backToHome
    case backToLogin
  }
  
  @Dependency(\.authAPIClient) private var authAPIClient
  @Dependency(\.bundleClient) private var bundleClient
  @Dependency(\.kakaoLoginClient) private var kakaoLoginClient
  @Dependency(\.keyChainClient) private var keyChainClient
  @Dependency(\.userDefaultsClient) private var userDefaultsClient
  @Dependency(\.userNotificationClient) private var userNotificationCenterClient
  @Dependency(\.uiApplicationClient) private var uiApplicationClient
  @Dependency(\.appleLoginAPIClient) private var appleLoginAPIClient
  
  public var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .binding:
        return .none
        
      case .checkPushStatus:
        return .run { send in
          let authorizationStatus = await userNotificationCenterClient.getAuthorizationStatus()
          var isPushOn: Bool
          
          switch authorizationStatus {
          case .authorized, .notDetermined, .ephemeral:
            isPushOn = true
          case .denied, .provisional:
            isPushOn = false
          @unknown default:
            isPushOn = false
          }
          
          await send(.updatePushStatus(isPushOn))
        } catch: { error, send in
          await send(.logError(MyPageCoreError(code: .failToGetCurrentVersion)))
        }
        
      case .checkCurrentVersion:
        return .run { send in
          let version = try bundleClient.getCurrentVersion()
          
          await send(.updateCurrentVersion(version))
        }
        
      case let .showPopup(isPopupPresented, popupType):
        state.isPopupPresented = isPopupPresented
        state.popupType = popupType
        state.popupTitle = popupType?.title ?? "타이틀"
        state.popupDescription = popupType?.description
        state.popupLeftButtonTitle = popupType?.leftButtonTitle ?? "왼쪽"
        state.popupRightButtonTitle = popupType?.rightButtonTitle ?? "오른쪽"
        return .none
        
      case .openSetting:
        return .run { send in
          let settingURL = await uiApplicationClient.getSettingURL()
          let isSettingOpened = try await uiApplicationClient.openURL(settingURL)
          
          if !isSettingOpened {
            await send(.showError(true, .setting))
          }
        } catch: { error, send in
          await send(.logError(MyPageCoreError(code: .failToGetOpenUrl)))
        }
        
      case .logout:
        return .run(
          operation: { send in
            try await keyChainClient.deleteUserInfo()
            await send(.backToLogin)
          },
          catch: { error, send in
            await send(.logError(MyPageCoreError(code: .failToLogout)))
          }
        )
        
      case let .updatePushStatus(pushStatus):
        state.alarmStatus = pushStatus ? .on : .off
        return .none
        
      case let .updateCurrentVersion(version):
        state.currentVersion = version
        return .none
        
      case let .showError(isErrorPresented, errorType):
        state.isErrorPresented = isErrorPresented
        state.errorType = errorType
        state.errorMessage = errorType.message
        return .none
        
      case .withdraw:
        return .run(
          operation: { [state] send in
            let loginType = state.userInfo.loginType
            switch loginType {
            case .kakao:
              await send(.withdrawAccount)
            case .apple:
              await send(.getRefreshToken)
            }
          }
        )
        
      case let .revokeAppleID(.success(token)):
        return .run { send in
          await send(.revokeAppleIDResponse(Result { try await self.appleLoginAPIClient.revoke(clientID: self.bundleClient.getBundleID(), token: token) }))
        }
        
      case .revokeAppleID(.failure):
        return .run { send in
          await send(.logError(MyPageCoreError(code: .failToReadRefreshToken)))
        }
        
      case .revokeAppleIDResponse(.success):
        return .run { send in
          await send(.withdrawAccount)
        }
        
      case .revokeAppleIDResponse(.failure):
        return .none
        
      case .withdrawAccount:
        return .run(
          operation: { [state] send in
            let accessToken = state.userInfo.accessToken
            _ = try await self.authAPIClient.withdrawAccount(accessToken)
            try await keyChainClient.deleteUserInfo()
            try await keyChainClient.deleteRefreshToken()
            await send(.backToLogin)
          },
          catch: { error, send in
            await send(.logError(MyPageCoreError(code: .failToWithdraw)))
            await send(.showError(true, .withdraw))
          }
        )
        
      case let .logError(error):
        return .run { send in
          logger.error("MyPage Error: \(error)")
        }
        
      case .getRefreshToken:
        return .run { send in
          await send(.revokeAppleID(Result { try await self.keyChainClient.readRefreshToken() }))
        }
        
      case .backToHome:
        return .none
        
      case .backToLogin:
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
    case failToGetCurrentVersion
    case failToGetOpenUrl
    case failToLogout
    case failToWithdraw
    case failToReadRefreshToken
  }
}
