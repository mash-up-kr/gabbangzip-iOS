//
//  AppDelegateReducer.swift
//  App
//
//  Created by YangJoonHyeok on 6/8/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import ComposableArchitecture
import Services

@Reducer
struct AppDelegateReducer {
  @ObservableState
  struct State: Equatable {
  }

  enum Action {
    case didFinishLaunching
    case userNotifications(UserNotificationClient.DelegateEvent)
  }
  
  @Dependency(\.userNotificationClient) private var userNotificationClient

  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .didFinishLaunching:
        return .run { @MainActor send in
          // TODO: 써드파티 SDK 초기화 및 설정
          
          self.userNotificationClient.requestAuthorization()
          
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
      }
    }
  }
}
