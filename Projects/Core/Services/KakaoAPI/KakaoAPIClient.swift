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

@DependencyClient
public struct KakaoAPIClient {
  public var login: @Sendable (
    _ idToken: String,
    _ nickname: String,
    _ profileImage: String
  ) async throws -> PICUserInformation
}

extension KakaoAPIClient: DependencyKey {
  public static var liveValue: KakaoAPIClient {
    return KakaoAPIClient(
      login: { idToken, nickname, profileImage in
        let provider = "KAKAO"
        let route = KakaoAPI.login(
          idToken,
          provider,
          nickname,
          profileImage
        )
        let request = Request<KakaoResponse>(route: route)
        print(request)
        do {
          let response = try await NetworkManager.shared.send(request)
          print(response)
          let user = try JSONDecoder().decode(KakaoResponse.self, from: response.data).data
          
          return user
        } catch {
          throw KakaoAPIClientError(
            code: .failToGetPICUserInformation,
            underlying: error
          )
        }
      }
    )
  }
}

extension DependencyValues {
  public var loginAPIClient: KakaoAPIClient {
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
  }
}
