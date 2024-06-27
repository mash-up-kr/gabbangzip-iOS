//
//  LoginCore.swift
//  Main
//
//  Created by Hyun A Song on 6/24/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import ComposableArchitecture
import Foundation
import KakaoSDKUser
import Models
import Services

@Reducer
public struct LoginCore {
  public init() {}
  
  @ObservableState
  public struct State: Equatable {
    public var errorMessage: String?
    public var kakaoUser: KaKaoUserInformation
    public var kakaoIdToken: KakaoToken
    
    public init(
      errorMessage: String? = nil,
      kakaoUser: KaKaoUserInformation = KaKaoUserInformation(),
      kakaoIdToken: KakaoToken = KakaoToken()
    ) {
      self.errorMessage = errorMessage
      self.kakaoUser = kakaoUser
      self.kakaoIdToken = kakaoIdToken
    }
  }
  
  public enum Action {
    case loginButtonTapped
    case loginWithKakaoTalkResponse(Result<String?, Error>)
    case loginWithKakaoAccountResponse(Result<String?, Error>)
    case checkUserInformationResponse(Result<User, Error>)
    case loginResponse(Result<PICUserInformation?, Error>)
    case saveTokenInKeyChain(Result<(KeyChainClient.Key, String), LoginCoreError>)
    case showError(String)
    case hideError
  }
  
  @Dependency(\.kakaoLoginClient) private var kakaoLoginClient
  @Dependency(\.kakaoAPIClient) private var kakaoAPIClient
  @Dependency(\.keyChainClient) private var keyChainClient
  
  public var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .loginButtonTapped:
        return .run { send in
          if kakaoLoginClient.isKakaoTalkLoginAvailable() {
            await send(
              .loginWithKakaoTalkResponse(
                Result {
                  try await self.kakaoLoginClient.loginWithKakaoTalk()
                }
              )
            )
          } else {
            await send(
              .loginWithKakaoAccountResponse(
                Result {
                  try await self.kakaoLoginClient.loginWithKakaoAccount()
                }
              )
            )
          }
        }
        
      case let .loginWithKakaoTalkResponse(.success(idToken)):
        state.kakaoIdToken.idToken = idToken
        return .run { send in
          await send(
            .checkUserInformationResponse(
              Result {
                try await kakaoLoginClient.checkUserInformation()
              }
            )
          )
        }
        
      case .loginWithKakaoTalkResponse(.failure):
        return .run { send in
          await send(.showError("로그인에 실패했어요."))
        }
        
      case let .loginWithKakaoAccountResponse(.success(idToken)):
        state.kakaoIdToken.idToken = idToken
        return .run { send in
          await send(
            .checkUserInformationResponse(
              Result {
                try await kakaoLoginClient.checkUserInformation()
              }
            )
          )
        }
        
      case .loginWithKakaoAccountResponse(.failure):
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
          await send(
            .loginResponse(
              Result {
                try await kakaoAPIClient.login(
                  idToken,
                  nickname,
                  profileImageUrl
                )
              }
            )
          )
        }
        
      case .checkUserInformationResponse(.failure):
        return .run { send in
          await send(.showError("로그인에 실패했어요."))
        }
        
      case let .loginResponse(.success(user)):
        return .run { send in
          if let accessToken = user?.accessToken {
            await send(.saveTokenInKeyChain(.success((.accessToken, accessToken))))
          } else {
            await send(.saveTokenInKeyChain(.failure(LoginCoreError(code: .failToGetAccessToken))))
          }
          if let refreshToken = user?.refreshToken {
            await send(.saveTokenInKeyChain(.success((.refreshToken, refreshToken))))
          } else {
            await send(.saveTokenInKeyChain(.failure(LoginCoreError(code: .failToGetRefreshToken))))
          }
        }
        
      case .loginResponse(.failure):
        return .run { send in
          await send(.showError("로그인에 실패했어요."))
        }
        
      case let .saveTokenInKeyChain(.success((tokenKey, token))):
        return .run { send in
          try await keyChainClient.create(tokenKey, token)
        }
        
      case .saveTokenInKeyChain(.failure):
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

// MARK: - LoginCoreError
public struct LoginCoreError: GabbangzipError {
  public var userInfo: [String: Any] = [:]
  public var code: Code
  public var underlying: Error?
  
  public enum Code: Int {
    case failToGetAccessToken
    case failToGetRefreshToken
  }
}
