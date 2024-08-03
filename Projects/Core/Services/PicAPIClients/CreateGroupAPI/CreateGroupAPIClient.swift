//
//  CreateGroupAPIClient.swift
//  Services
//
//  Created by YangJoonHyeok on 8/1/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import ComposableArchitecture
import Get
import Models

@DependencyClient
public struct CreateGroupAPIClient: Sendable {
  public var createGroup: @Sendable (
    _ accessToken: String,
    _ groupName: String,
    _ keyword: String,
    _ groupImageURL: String
  ) async throws -> CreatedGroupInfo
}

extension CreateGroupAPIClient: DependencyKey {
  public static var liveValue: CreateGroupAPIClient {
    return CreateGroupAPIClient(
      createGroup: { accessToken, groupName, keyword, groupImageURL in
        let route = CreateGroupAPI.createGroup(
          accessToken: accessToken,
          groupName: groupName,
          keyword: keyword,
          groupImageURL: groupImageURL
        )
        let request = Request<SuccessResponse<CreatedGroupInfo>>(route: route)
        do {
          let response = try await NetworkManager.shared.send(request)
          return response.value.data
        } catch {
          throw CreateGroupAPIClientError(
            code: .getAPIError,
            underlying: error
          )
        }
      }
    )
  }
  
  public static var testValue: CreateGroupAPIClient {
    return CreateGroupAPIClient()
  }
}

extension DependencyValues {
  public var createGroupAPIClient: CreateGroupAPIClient {
    get { self[CreateGroupAPIClient.self] }
    set { self[CreateGroupAPIClient.self] = newValue }
  }
}

public struct CreateGroupAPIClientError: GabbangzipError {
  public var userInfo: [String: Any]
  public var code: APIResponseError
  public var underlying: Error?

  public init(
    userInfo: [String: Any] = [:],
    code: APIResponseError,
    underlying: Error? = nil
  ) {
    self.userInfo = userInfo
    self.code = code
    self.underlying = underlying
  }

  public enum APIResponseError: Int {
    case getAPIError = 0
  }
}

