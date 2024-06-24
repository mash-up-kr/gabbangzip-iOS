//
//  RootCore.swift
//  App
//
//  Created by Hyun A Song on 6/19/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import ComposableArchitecture
import Foundation
import KakaoSDKUser
import Models
import Services

@Reducer
public struct RootCore {
  @ObservableState
  public struct State: Equatable {
    public var errorMessage: String?
    public var kakaoUser: KaKaoUserInformation = KaKaoUserInformation()
    public var kakaoIdToken: KakaoToken = KakaoToken()
    
    init() {}
  }
  
  public enum Action {
    case loginButtonTapped
    case onOpenURL(URL)
    case loginWithKakaoTalkResponse(Result<String?, Error>)
    case loginWithKakaoAccountResponse(Result<String?, Error>)
    case checkUserInformationResponse(Result<User, Error>)
    case loginResponse(Result<PICUserInformation?, Error>)
    case saveAccessTokenInKeyChain(String)
    case saveRefreshTokenInKeyChain(String)
    case showError(String)
    case hideError
  }
  
  @Dependency(\.kakaoLoginClient) private var kakaoLoginClient
  @Dependency(\.loginAPIClient) private var loginAPIClient
  @Dependency(\.keyChainClient) private var keyChainClient
  
  public var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .loginButtonTapped:
        return .run { send in
          if kakaoLoginClient.isKakaoTalkLoginAvailable() {
            await send(.loginWithKakaoTalkResponse(Result { try await
              self.kakaoLoginClient.loginWithKakaoTalk()
            }))
          } else {
            await send(.loginWithKakaoAccountResponse(Result { try await
              self.kakaoLoginClient.loginWithKakaoAccount()
            }))
          }
        }
        
      case let .onOpenURL(url):
        return .run { send in
          kakaoLoginClient.openURL(url)
        }
        
      case let .loginWithKakaoTalkResponse(.success(idToken)):
        state.kakaoIdToken.idToken = idToken
        return .run { send in
          await send(.checkUserInformationResponse(Result { try await
            kakaoLoginClient.checkUserInformation()
          }))
        }
        
      case let .loginWithKakaoTalkResponse(.failure(error)):
        return .run { send in
          await send(.showError("로그인에 실패했어요."))
        }
        
      case let .loginWithKakaoAccountResponse(.success(idToken)):
        state.kakaoIdToken.idToken = idToken
        return .run { send in
          await send(.checkUserInformationResponse(Result { try await
            kakaoLoginClient.checkUserInformation()
          }))
        }
        
      case let .loginWithKakaoAccountResponse(.failure(error)):
        return .run { send in
          await send(.showError("로그인에 실패했어요."))
        }
        
      case let .checkUserInformationResponse(.success(user)):
        state.kakaoUser.nickname = user.kakaoAccount?.profile?.nickname
        state.kakaoUser.profileImageUrl = user.kakaoAccount?.profile?.profileImageUrl
        return .run { [state] send in
          let idToken = state.kakaoIdToken.idToken ?? ""
          let nickname = state.kakaoUser.nickname ?? ""
          let profileImageUrl = state.kakaoUser.profileImageUrl?.absoluteString ?? ""
          await send(.loginResponse(Result { try await
            loginAPIClient.login(
              idToken,
              nickname,
              profileImageUrl
            )
          }))
        }
        
      case let .checkUserInformationResponse(.failure(error)):
        return .run { send in
          await send(.showError("로그인에 실패했어요."))
        }
        
      case let .loginResponse(.success(user)):
        return .run { send in
          await send(.saveAccessTokenInKeyChain(user?.accessToken ?? ""))
          await send(.saveRefreshTokenInKeyChain(user?.refreshToken ?? ""))
        }
        
      case let .loginResponse(.failure(error)):
        return .run { send in
          await send(.showError("로그인에 실패했어요."))
        }
        
      case let .saveAccessTokenInKeyChain(accessToken):
        return .run { send in
          try await keyChainClient.create(.accessToken, accessToken)
        }
        
      case let .saveRefreshTokenInKeyChain(refreshToken):
        return .run { send in
          try await keyChainClient.create(.refreshToken, refreshToken)
        }
        
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
