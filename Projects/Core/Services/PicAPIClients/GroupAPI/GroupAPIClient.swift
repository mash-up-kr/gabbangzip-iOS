//
//  GroupAPIClient.swift
//  Services
//
//  Created by YangJoonHyeok on 7/2/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import ComposableArchitecture
import Foundation
import Get
import Models

@DependencyClient
public struct GroupAPIClient: Sendable {
  public var getGroups: @Sendable (_ accessToken: String) async throws -> GroupsData
}

extension GroupAPIClient: DependencyKey {
  public static var liveValue: GroupAPIClient {
    return GroupAPIClient(
      getGroups: { accessToken in
        let route = GroupAPI.getGroups(accessToken: accessToken)
        let request = Request<SuccessResponse<GroupsData>>(route: route)
        do {
          let response = try await NetworkManager.shared.send(request)
          return response.value.data
        } catch {
          throw GroupAPIClientError(
            code: .failToGetGroups,
            underlying: error
          )
        }
      }
    )
  }
  
  public static var previewValue: GroupAPIClient {
    return GroupAPIClient(
      getGroups: { _ in
        return GroupsData.mock
      }
    )
  }
}

extension DependencyValues {
  public var groupAPIClient: GroupAPIClient {
    get { self[GroupAPIClient.self] }
    set { self[GroupAPIClient.self] = newValue }
  }
}

// MARK: - KakaoAPIClientError
public struct GroupAPIClientError: GabbangzipError {
  public var userInfo: [String: Any] = [:]
  public var code: APIResponseError
  public var underlying: Error?

  public enum APIResponseError: Int {
    case failToGetGroups
  }
}

