//
//  KakaoAPIClient.swift
//  Services
//
//  Created by Hyun A Song on 6/22/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import ComposableArchitecture
import Foundation
import Get
import Models

@DependencyClient
public struct KakaoAPIClient {
  public var login: @Sendable (
    _ idToken: String,
    _ nickname: String,
    _ profileImage: String
  ) async throws -> PICUserInformation?
  public var refreshToken: @Sendable (_ refreshToken: String) async throws -> TokenInformation?
  public var testToken: @Sendable (_ accessToken: String) async throws -> TestInformation?
  public var delete: @Sendable (_ accessToken: String) async throws -> DeleteUserInformation?
}

extension KakaoAPIClient: DependencyKey {
  public static var liveValue: KakaoAPIClient {
    return KakaoAPIClient(
      login: { idToken, nickname, profileImage in
        let provider = "KAKAO"
        let route = KakaoAPI.login(
          idToken: idToken,
          provider: provider,
          nickname: nickname,
          profileImage: profileImage
        )
        let request = Request<PICUserResponse>(route: route)
        do {
          let response = try await NetworkManager.shared.send(request)
          
          return response.value.data
        } catch {
          throw KakaoAPIClientError(code: .failToGetPICUserInformation)
        }
      },
      refreshToken: { refreshToken in
        let route = KakaoAPI.refresh(refreshToken: refreshToken)
        let request = Request<TokenResponse>(route: route)
        do {
          let response = try await NetworkManager.shared.send(request)
          
          return response.value.data
        } catch {
          throw KakaoAPIClientError(code: .failToGetTokenInformation)
        }
      },
      testToken: { accessToken in
        let route = KakaoAPI.refresh(refreshToken: refreshToken)
        let request = Request<TestResponse>(route: route)
        do {
          let response = try await NetworkManager.shared.send(request)
          
          return response.value.data
        } catch {
          throw KakaoAPIClientError(code: .failToTest)
        }
      },
      delete: { accessToken in
        let route = KakaoAPI.refresh(refreshToken: refreshToken)
        let request = Request<DeleteUserResponse>(route: route)
        do {
          let response = try await NetworkManager.shared.send(request)
          
          return response.value.data
        } catch {
          throw KakaoAPIClientError(code: .failToDeleteUserInformation)
        }
      }
    )
  }
}

extension DependencyValues {
  public var kakaoAPIClient: KakaoAPIClient {
    get { self[KakaoAPIClient.self] }
    set { self[KakaoAPIClient.self] = newValue }
  }
}

// MARK: - KakaoAPIClientError
public struct KakaoAPIClientError: GabbangzipError {
  public var userInfo: [String: Any] = [:]
  public var code: APIResponseError
  public var underlying: Error?

  public enum APIResponseError: Int {
    case failToGetPICUserInformation
    case failToGetTokenInformation
    case failToTest
    case failToDeleteUserInformation
  }
}
