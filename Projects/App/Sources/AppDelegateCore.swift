//
//  AppDelegateReducer.swift
//  App
//
//  Created by YangJoonHyeok on 6/8/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import Common
import ComposableArchitecture
import Services

@Reducer
struct AppDelegateCore {
  @ObservableState
  struct State: Equatable {
  }

  enum Action {
    case didFinishLaunching
    case userNotifications(UserNotificationClient.DelegateEvent)
    case authorizationStatusResposne(Result<Void, Error>)
    case showError(AppDelegateCoreError)
  }
  
  @Dependency(\.userNotificationClient) private var userNotificationClient
  @Dependency(\.bundleClient) private var bundleClient
  @Dependency(\.kakaoLoginClient) private var kakaoLoginClient

  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .didFinishLaunching:
        return .run { @MainActor send in
          // TODO: 써드파티 SDK 초기화 및 설정
          if let appKey = try bundleClient.getValue("KakaoNativeAppKey") as? String {
            await kakaoLoginClient.initSDK(appKey)
          } else {
            send(.showError(AppDelegateCoreError(code: .failToStringTypeCasting)))
          }
          
          let authorizationStatus = await self.userNotificationClient.getAuthorizationStatus()
          if authorizationStatus == .notDetermined {
            await send(
              .authorizationStatusResposne(
                Result {
                  try await self.userNotificationClient.requestAuthorization()
                }
              )
            )
          }
          
          for await event in self.userNotificationClient.delegate() {
            send(.userNotifications(event))
          }
        }
        
      case let .userNotifications(.didReceiveResponse(response, completionHandler)):
        // TODO: 푸시 알림 처리
        return .none
        
      case let .userNotifications(.willPresentNotification(notification, completionHandler)):
        // MARK: - UNNotificationPresentationOptions로 foreground 에서도 노티 수신 방법 설정
        return .run { send in
          completionHandler([.banner, .badge, .sound])
        }
        
      case let .authorizationStatusResposne(.success(status)):
        return .none
        
      case let .authorizationStatusResposne(.failure(error)):
        return .none
        
      case let .showError(error):
        logger.error("RootCore Error: \(String(describing: error))")
        return .none
      }
    }
  }
}

// MARK: - AppDelegateCoreError
public struct AppDelegateCoreError: GabbangzipError {
  public var userInfo: [String: Any] = [:]
  public var code: Code
  public var underlying: Error?
  
  public enum Code: Int {
    case failToStringTypeCasting
  }
}
