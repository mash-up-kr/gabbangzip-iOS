//
//  KakaoLoginClient.swift
//  Services
//
//  Created by Hyun A Song on 6/13/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import ComposableArchitecture
import Foundation
import KakaoSDKAuth
import KakaoSDKCommon
import KakaoSDKUser

@DependencyClient
public struct KakaoLoginClient {
  public var initSDK: @Sendable (_ appKey: String) async -> Void
  public var openURL: @Sendable (_ url: URL) -> Bool = { url in false }
  public var isKakaoTalkLoginAvailable: @Sendable () -> Bool = { false }
  public var checkUserInformation: @Sendable () async throws -> User
  public var loginWithKakaoTalk: @Sendable () async throws -> String?
  public var loginWithKakaoAccount: @Sendable () async throws -> String?
  public var logout: @Sendable () async throws -> Void
}

extension KakaoLoginClient: DependencyKey {
  public static var liveValue: KakaoLoginClient {
    return .init(
      initSDK: { appKey in
        KakaoSDK.initSDK(appKey: appKey)
      },
      openURL: { url in
        if AuthApi.isKakaoTalkLoginUrl(url) {
          return AuthController.handleOpenUrl(url: url)
        } else {
          return false
        }
      },
      isKakaoTalkLoginAvailable: {
        UserApi.isKakaoTalkLoginAvailable()
      },
      checkUserInformation: {
        try await withCheckedThrowingContinuation { continuation in
          UserApi.shared.me() { user, error in
            if error != nil {
              continuation.resume(throwing: KakaoLoginClientError(code: .failToGetMe))
            } else if let user {
              continuation.resume(returning: user)
            } else {
              continuation.resume(throwing: KakaoLoginClientError(code: .failToGetUserInformation))
            }
          }
        }
      },
      loginWithKakaoTalk: { @MainActor in
        try await withCheckedThrowingContinuation { continuation in
          UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
            if error != nil {
              continuation.resume(throwing: KakaoLoginClientError(code: .failToGetOauthToken))
            } else if let oauthToken {
              continuation.resume(returning: oauthToken.idToken)
            } else {
              continuation.resume(throwing: KakaoLoginClientError(code: .failToLoginWithKakaoTalk))
            }
          }
        }
      },
      loginWithKakaoAccount: { @MainActor in
        try await withCheckedThrowingContinuation { continuation in
          UserApi.shared.loginWithKakaoAccount { oauthToken, error in
            if error != nil {
              continuation.resume(throwing: KakaoLoginClientError(code: .failToGetOauthToken))
            } else if let oauthToken {
              continuation.resume(returning: oauthToken.idToken)
            } else {
              continuation.resume(throwing: KakaoLoginClientError(code: .failToLoginWithKakaoAccount))
            }
          }
        }
      },
      logout: {
        try await withCheckedThrowingContinuation { continuation in
          UserApi.shared.logout { error in
            if error != nil {
              continuation.resume(throwing: KakaoLoginClientError(code: .failToLogout))
            } else {
              continuation.resume(returning: ())
            }
          }
        }
      }
    )
  }
}

extension DependencyValues {
  public var kakaoLoginClient: KakaoLoginClient {
    get { self[KakaoLoginClient.self] }
    set { self[KakaoLoginClient.self] = newValue }
  }
}

// MARK: - KakaoLoginClientError
public struct KakaoLoginClientError: GabbangzipError {
  public var userInfo: [String: Any] = [:]
  public var code: Code
  public var underlying: Error?
  
  public enum Code: Int {
    case failToGetMe
    case failToGetUserInformation
    case failToGetOauthToken
    case failToLoginWithKakaoTalk
    case failToLoginWithKakaoAccount
    case failToLogout
  }
}
