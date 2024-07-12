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
    public var nickname: String
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
      nickname: String,
      currentVersion: String,
      alarmStatus: AlarmStatus,
      errorType: MyPageError? = nil,
      errorMessage: String,
      popupType: MyPagePopup? = nil,
      popupTitle: String,
      popupDescription: String? = nil,
      popupLeftButtonTitle: String,
      popupRightButtonTitle: String,
      isPopupPresented: Bool = false,
      isLoginViewPresented: Bool = false,
      isErrorPresented: Bool = false
    ) {
      self.nickname = nickname
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
    case checkPushOn
    case showPopup(Bool, State.MyPagePopup?)
    case openSetting
    case logout
    
    // Internal Action
    case updatePushStatus(Bool)
    case showLoginView
    case showError(Bool, State.MyPageError)
    case withdraw
    case getAccessTokenToDelete
    case deleteUser(String)
    case deleteUserInfo
    case logError(MyPageCoreError)
  }
  
  @Dependency(\.userDefaultsClient) private var userDefaultsClient
  @Dependency(\.userNotificationClient) private var userNotificationCenterClient
  @Dependency(\.uiApplicationClient) private var uiApplicationClient
  @Dependency(\.kakaoAPIClient) private var kakaoAPIClient
  @Dependency(\.kakaoLoginClient) private var kakaoLoginClient
  @Dependency(\.keyChainClient) private var keyChainClient
  
  public var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .binding:
        return .none
        
      case .checkPushOn:
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
          await send(.logError(MyPageCoreError(code: .alarmStatusError)))
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
        return .run { send in
          try await kakaoLoginClient.logout()
          await send(.deleteUserInfo)
          await send(.showLoginView)
        } catch: { error, send in
          await send(.logError(MyPageCoreError(code: .failToLogout)))
        }
        
      case let .updatePushStatus(pushStatus):
        state.alarmStatus = pushStatus ? .on : .off
        return .none
        
      case .showLoginView:
        // TODO: - Coordinator에게 일임해야 함
        state.isLoginViewPresented = true
        return .none
        
      case let .showError(isErrorPresented, errorType):
        state.isErrorPresented = isErrorPresented
        state.errorType = errorType
        state.errorMessage = errorType.message
        return .none
        
      case .withdraw:
        return .run { send in
          try await kakaoLoginClient.logout()
          await send(.getAccessTokenToDelete)
          await send(.deleteUserInfo)
          await send(.showLoginView)
        } catch: { error, send in
          await send(.logError(MyPageCoreError(code: .failToWithdraw)))
          await send(.showError(true, .withdraw))
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
        
      case let .logError(error):
        return .run { send in
          logger.error("MyPage Error: \(error)")
        }
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
