//
//  VoteAPI.swift
//  Models
//
//  Created by hyerin on 8/3/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import Common
import Foundation
import Get
import Models

public enum VoteAPI {
  case getVoteOptions(accessToken: String, eventID: Int)
  case postVoteResult(accessToken: String, eventID: Int, likedOptionIDs: [Int])
}

extension VoteAPI: RouteType {
  public var path: String {
    switch self {
    case let .getVoteOptions(_, eventID):
      return "/api/v1/votes/\(eventID)/options"
    case .postVoteResult:
      return "/api/v1/votes"
    }
  }
  
  public var method: HTTPMethod {
    switch self {
    case .getVoteOptions:
      return .get
    case .postVoteResult:
      return .post
    }
  }
  
  public var query: [(String, String?)]? {
    switch self {
    case .getVoteOptions, .postVoteResult:
      nil
    }
  }
  
  public var body: Encodable? {
    switch self {
    case .getVoteOptions:
      return nil
    case .postVoteResult(_, let eventID, let likedOptionIDs):
      let voteReqDTO = VoteReqDTO(eventID: eventID, likedOptionIDs: likedOptionIDs)
      return voteReqDTO
    }
  }
  
  public var headers: [String: String]? {
    switch self {
    case let .getVoteOptions(accessToken, _), let .postVoteResult(accessToken, _, _):
      let headers: [String: String]? = [
        "Authorization": "Bearer \(accessToken)"
      ]
      return headers
    }
  }
}

