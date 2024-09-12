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
  public var getGroupDetail: @Sendable (_ accessToken: String, _ groupID: Int) async throws -> GroupDetailInfo
  public var joinGroup: @Sendable (_ accessToken: String, _ code: String) async throws -> GroupID
  public var getMemberList: @Sendable (_ accessToken: String, _ groupID: Int) async throws -> MemberList
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
      },
      getGroupDetail: { accessToken, groupID in
        let route = GroupAPI.getGroupDetail(accessToken: accessToken, groupID: groupID)
        let request = Request<SuccessResponse<GroupDetailInfo>>(route: route)
        do {
          let response = try await NetworkManager.shared.send(request)
          return response.value.data
        } catch {
          throw GroupAPIClientError(
            code: .failToGetGroupDetail,
            underlying: error
          )
        }
      },
      joinGroup: { accessToken, code in
        let route = GroupAPI.joinGroup(accessToken: accessToken, code: code)
        let request = Request<SuccessResponse<GroupID>>(route: route)
        do {
          let response = try await NetworkManager.shared.send(request)
          return response.value.data
        } catch {
          throw GroupAPIClientError(
            code: .failToJoinGroup,
            underlying: error
          )
        }
      },
      getMemberList: { accessToken, groupID in
        let route = GroupAPI.getMemberList(accessToken: accessToken, groupID: groupID)
        let request = Request<SuccessResponse<MemberList>>(route: route)
        do {
          let response = try await NetworkManager.shared.send(request)
          return response.value.data
        } catch {
          throw GroupAPIClientError(
            code: .failToGetMemberList,
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
      },
      getGroupDetail: { _, _ in
        return GroupDetailInfo.mock
      },
      joinGroup: { _, _ in
        return GroupID.mock
      },
      getMemberList: { _, _ in
        return MemberList.mock
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
    case failToGetGroupDetail
    case failToJoinGroup
    case failToGetMemberList
  }
}

