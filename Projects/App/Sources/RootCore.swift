//
//  RootCore.swift
//  App
//
//  Created by Hyun A Song on 6/19/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import ComposableArchitecture
import Foundation
import Services
import KakaoSDKUser
import Models

@Reducer
public struct RootCore {
  @ObservableState
  public struct State: Equatable {
    var errorMessage: String?
    
    public init() {}
  }
  
  public enum Action {
    case loginButtonTapped
    case onOpenURL(URL)
    case loginWithKakaoTalkResponse(Result<String, Error>)
    case loginWithKakaoAccountResponse(Result<String, Error>)
    case checkUserInformationResponse(Result<User, Error>)
    case loginResponse(Result<PICUserInformation, Error>)
    case saveInKeyChain(Result<String, Error>)
    case showError(String)
    case hideError
  }
  
  @Dependency(\.kakaoLoginClient) var kakaoLoginClient
  @Dependency(\.loginAPIClient) var loginAPIClient
  @Dependency(\.keyChainClient) var keyChainClient
  
  public var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .loginButtonTapped:
        return .run { send in
          if self.kakaoLoginClient.isKakaoTalkLoginAvailable() {
            await send(.loginWithKakaoTalkResponse(Result { try await
              self.kakaoLoginClient.loginWithKakaoTalk() }))
          } else {
            await send(.loginWithKakaoAccountResponse(Result { try await self.kakaoLoginClient.loginWithKakaoAccount() }))
          }
        }
        
      case let .onOpenURL(url):
        return .run { send in
          kakaoLoginClient.openURL(url)
        }
        
      case let .loginWithKakaoTalkResponse(.success(accessToken)):
        return .run { send in
          await send(.checkUserInformationResponse(Result { try await 
            self.kakaoLoginClient.checkUserInformation() }))
        }
        
      case let .loginWithKakaoTalkResponse(.failure(error)):
        return .none
        
      case let .loginWithKakaoAccountResponse(.success(accessToken)):
        return .run { send in
          await send(.checkUserInformationResponse(Result { try await 
            self.kakaoLoginClient.checkUserInformation() }))
        }
        
      case let .loginWithKakaoAccountResponse(.failure(error)):
        return .none
        
      case let .checkUserInformationResponse(.success(user)):
        return .run { send in
          //          self.loginAPIClient.login(user, token, image)
        }
        
      case let .checkUserInformationResponse(.failure(error)):
        return .none
        
      case let .loginResponse(.success(user)):
        return .none
        
      case let .loginResponse(.failure(error)):
        return .none
        
      case .saveInKeyChain(_):
        return .none
        
      case let .showError(message):
        state.errorMessage = message
        return .none
        
      case .hideError:
        state.errorMessage = nil
        return .none
      }
    }
  }
}
