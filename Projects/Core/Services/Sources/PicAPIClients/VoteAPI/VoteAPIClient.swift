//
//  VoteAPIClient.swift
//  Models
//
//  Created by hyerin on 8/3/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import ComposableArchitecture
import Foundation
import Get
import Models

@DependencyClient
public struct VoteAPIClient: Sendable {
  public var getVoteOptions: @Sendable (_ accessToken: String, _ eventID: Int) async throws -> VoteOptionInfo
  public var postVoteResult: @Sendable(_ accessToken: String, _ eventID: Int, _ likedOptionIDs: [Int]) async throws -> VoteCompleteInfo
}

extension VoteAPIClient: DependencyKey {
  public static var liveValue: VoteAPIClient {
    return VoteAPIClient(
      getVoteOptions: { accessToken, eventID in
        let route = VoteAPI.getVoteOptions(accessToken: accessToken, eventID: eventID)
        let request = Request<SuccessResponse<VoteOptionInfo>>(route: route)
        do {
          let response = try await NetworkManager.shared.send(request)
          return response.value.data
        } catch {
          throw VoteAPIClientError(
            code: .getAPIError,
            underlying: error
          )
        }
      },
      postVoteResult: { accessToken, eventID, likedOptionIDs in
        let route = VoteAPI.postVoteResult(accessToken: accessToken, eventID: eventID, likedOptionIDs: likedOptionIDs)
        let request = Request<SuccessResponse<VoteCompleteInfo>>(route: route)
        do {
          let response = try await NetworkManager.shared.send(request)
          return response.value.data
        } catch {
          throw VoteAPIClientError(
            code: .getAPIError,
            underlying: error
          )
        }
      }
    )
  }
}

extension DependencyValues {
  public var voteAPIClient: VoteAPIClient {
    get { self[VoteAPIClient.self] }
    set { self[VoteAPIClient.self] = newValue }
  }
}

public struct VoteAPIClientError: GabbangzipError {
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
