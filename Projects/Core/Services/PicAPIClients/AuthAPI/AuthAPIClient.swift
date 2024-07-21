//
//  AuthAPIClient.swift
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
public struct AuthAPIClient: Sendable {
  public var login: @Sendable (
    _ idToken: String,
    _ nickname: String,
    _ profileImage: String
  ) async throws -> PICUserInfo
  public var refreshToken: @Sendable (_ refreshToken: String) async throws -> TokenInfo
  public var testToken: @Sendable (_ accessToken: String) async throws -> TestInfo
  public var withdrawAccount: @Sendable (_ accessToken: String) async throws -> DeleteUserInfo
}

extension AuthAPIClient: DependencyKey {
  public static var liveValue: AuthAPIClient {
    return AuthAPIClient(
      login: { idToken, nickname, profileImage in
        let provider = "KAKAO"
        let route = AuthAPI.login(
          idToken: idToken,
          provider: provider,
          nickname: nickname,
          profileImage: profileImage
        )
        let request = Request<SuccessResponse<PICUserInfo>>(route: route)
        do {
          let response = try await NetworkManager.shared.send(request)
          
          return response.value.data
        } catch {
          throw AuthAPIClientError(code: .failToGetPICUserInformation)
        }
      },
      refreshToken: { refreshToken in
        let route = AuthAPI.refresh(refreshToken: refreshToken)
        let request = Request<SuccessResponse<TokenInfo>>(route: route)
        do {
          let response = try await NetworkManager.shared.send(request)
          
          return response.value.data
        } catch {
          throw AuthAPIClientError(code: .failToGetTokenInformation)
        }
      },
      testToken: { accessToken in
        let route = AuthAPI.testToken(accessToken: accessToken)
        let request = Request<SuccessResponse<TestInfo>>(route: route)
        do {
          let response = try await NetworkManager.shared.send(request)
          
          return response.value.data
        } catch {
          throw AuthAPIClientError(code: .failToTest)
        }
      },
      withdrawAccount: { accessToken in
        let route = AuthAPI.delete(accessToken: accessToken)
        let request = Request<SuccessResponse<DeleteUserInfo>>(route: route)
        do {
          let response = try await NetworkManager.shared.send(request)
          
          return response.value.data
        } catch {
          throw AuthAPIClientError(code: .failToDeleteUserInformation)
        }
      }
    )
  }
}

extension DependencyValues {
  public var authAPIClient: AuthAPIClient {
    get { self[AuthAPIClient.self] }
    set { self[AuthAPIClient.self] = newValue }
  }
}

public struct AuthAPIClientError: GabbangzipError {
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
