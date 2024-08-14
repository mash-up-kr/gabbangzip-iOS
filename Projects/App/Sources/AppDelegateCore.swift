//
//  AppDelegateReducer.swift
//  App
//
//  Created by YangJoonHyeok on 6/8/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import Common
import ComposableArchitecture
import Foundation
import Services

@Reducer
struct AppDelegateCore {
  @ObservableState
  struct State: Equatable {
  }
  
  enum Action {
    case didFinishLaunching
    
    // KakaoSDK
    case setupKakaoSDK
    
    // Firebase
    case setupFirebase
    case configureFirebase
    case runFirebaseAutoInitialization
    case getDeviceToken(Data)
    
    // NotificationCenter
    case setupNotificationCenter
    case configureNotificationCenterDelegate
    case requestNotificationCenterAuthorization
    case userNotifications(UserNotificationClient.DelegateEvent)
    case authorizationStatusResposne(Result<Void, Error>)
    
    case logError(AppDelegateCoreError)
  }
  
  @Dependency(\.bundleClient) private var bundleClient
  @Dependency(\.firebaseClient) private var firebaseClient
  @Dependency(\.kakaoLoginClient) private var kakaoLoginClient
  @Dependency(\.uiApplicationClient) private var uiApplicationClient
  @Dependency(\.userNotificationClient) private var userNotificationClient
  
  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .didFinishLaunching:
        return .run { send in
          await send(.setupKakaoSDK)
          await send(.setupFirebase)
        }
        
      case .setupKakaoSDK:
        return .run { send in
          if let appKey = try bundleClient.getValue("KakaoNativeAppKey") as? String {
            await kakaoLoginClient.initSDK(appKey)
          } else {
            await send(.logError(AppDelegateCoreError(code: .failToStringTypeCasting)))
          }
        }
        
      case .setupFirebase:
        return .run { send in
          await send(.configureFirebase)
          await send(.setupNotificationCenter)
          await send(.runFirebaseAutoInitialization)
        }
        
      case .configureFirebase:
        return .run { send in
          await firebaseClient.configure()
        }
        
      case .checkRegisterToken:
        return .run { send in
          let token = try await firebaseClient.checkRegistrationToken()
          await send(.logFCMDescription(token))
        } catch: { _, send in
          await send(.logError(AppDelegateCoreError(code: .failToGetRegisterToken)))
        }
        
      case .runFirebaseAutoInitialization:
        return .run { send in
          await firebaseClient.runAutoInitialization()
        }
        
      case let .getDeviceToken(deviceToken):
        return .run { send in
          await firebaseClient.getDeviceToken(deviceToken)
        }
        
      case .setupNotificationCenter:
        return .run { send in
          await send(.configureNotificationCenterDelegate)
          await send(.requestNotificationCenterAuthorization)
        }
        
      case .configureNotificationCenterDelegate:
        return .run { send in
          for await event in await self.userNotificationClient.delegate() {
            await send(.userNotifications(event))
          }
        }
        
      case .requestNotificationCenterAuthorization:
        return .run { send in
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
          
          await uiApplicationClient.registerForRemoteNotifications()
        }
        
      case .userNotifications(.didReceiveResponse):
        // TODO: 푸시 알림 처리
        return .none
        
      case let .userNotifications(.willPresentNotification(_, completionHandler)):
        // MARK: - UNNotificationPresentationOptions로 foreground 에서도 노티 수신 방법 설정
        return .run { send in
          completionHandler([.banner, .badge, .sound])
        }
        
      case .authorizationStatusResposne(.success):
        return .none
        
      case let .authorizationStatusResposne(.failure(error)):
        return .run { send in
          await send(.logError(AppDelegateCoreError(code: .failToGetAuthorizationStatusResposne, underlying: error)))
        }
        
      case let .logError(error):
        return .run { send in
          logger.error("AppDelegateCore Error: \(String(describing: error))")
        }
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
    case failToGetAuthorizationStatusResposne
  }
}
