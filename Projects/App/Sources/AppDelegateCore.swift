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
    
    // KakaoSDK Setting
    case setUpKakaoSDK
    
    // Firebase Setting
    case setUpFirebase
    case configureFirebase
    case configureFirebaseDelegate
    case runFirebaseAutoInitialization
    case checkRegisterToken
    case getDeviceToken(Data)
    case messagingFCMToken(FirebaseClient.DelegateEvent)
    
    // NotificationCenter Setting
    case setUpNotificationCenter
    case configureNotificationCenterDelegate
    case requestNotificationCenterAuthorization
    case registerForRemoteNotifications
    case userNotifications(UserNotificationClient.DelegateEvent)
    case authorizationStatusResposne(Result<Void, Error>)
    
    case logError(AppDelegateCoreError)
  }
  
  @Dependency(\.userNotificationClient) private var userNotificationClient
  @Dependency(\.bundleClient) private var bundleClient
  @Dependency(\.kakaoLoginClient) private var kakaoLoginClient
  @Dependency(\.firebaseClient) private var firebaseClient
  @Dependency(\.uiApplicationClient) private var uiApplicationClient
  
  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .didFinishLaunching:
        return .run { send in
          await send(.setUpKakaoSDK)
          await send(.setUpFirebase)
        }
        
      case .setUpKakaoSDK:
        return .run { send in
          if let appKey = try bundleClient.getValue("KakaoNativeAppKey") as? String {
            await kakaoLoginClient.initSDK(appKey)
          } else {
            await send(.logError(AppDelegateCoreError(code: .failToStringTypeCasting)))
          }
        }
        
      case .setUpFirebase:
        return .run { send in
          await send(.configureFirebase)
          await send(.setUpNotificationCenter)
          await send(.configureFirebaseDelegate)
          await send(.checkRegisterToken)
          await send(.runFirebaseAutoInitialization)
        }
        
      case .configureFirebase:
        return .run { @MainActor send in
          firebaseClient.configure()
        }
        
      case .configureFirebaseDelegate:
        return .run { @MainActor send in
          for await event in self.firebaseClient.delegate() {
            send(.messagingFCMToken(event))
          }
        }
        
      case .runFirebaseAutoInitialization:
        return .run { send in
          await firebaseClient.runAutoInitialization()
        }
        
      case .checkRegisterToken:
        return .run { send in
          // You can get FCM Register Device Token using this method.
          let token = try await firebaseClient.checkRegistrationToken()
          print("FCM registration token: \(String(describing: token))")
        } catch: { _, send in
          await send(.logError(AppDelegateCoreError(code: .failToGetRegisterToken)))
        }
        
      case let .getDeviceToken(deviceToken):
        return .run { send in
          firebaseClient.getDeviceToken(deviceToken)
        }
        
      case let .messagingFCMToken(.messaging(messaging, fcmToken: fcmToken)):
        return .run { send in
          let dataDict: [String: String] = ["token": fcmToken ?? ""]
          
          NotificationCenter.default.post(
            name: Notification.Name("FCMToken"),
            object: nil,
            userInfo: dataDict
          )
          // TODO: If necessary send token to application server.
          // Note: This callback is fired at each app startup and whenever a new token is generated.
        }
        
      case .setUpNotificationCenter:
        return .run { send in
          await send(.configureNotificationCenterDelegate)
          await send(.requestNotificationCenterAuthorization)
          await send(.registerForRemoteNotifications)
        }
        
      case .configureNotificationCenterDelegate:
        return .run { @MainActor send in
          for await event in self.userNotificationClient.delegate() {
            send(.userNotifications(event))
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
        }
        
      case .registerForRemoteNotifications:
        return .run { send in
          await uiApplicationClient.registerForRemoteNotifications()
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
    case failToGetRegisterToken
  }
}
