//
//  MemberList.swift
//  Models
//
//  Created by hyerin on 8/8/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import Foundation

public struct MemberList: Decodable {
    let members: [Member]
    let invitationCode: String

    enum CodingKeys: String, CodingKey {
        case members
        case invitationCode = "invitation_code"
    }
}

// MARK: - Member
public struct Member: Decodable, Hashable {
  public let id: Int
  public let nickname: String
  
  public static var mockList: [Member] {
    [
      Member(
        id: 0,
        nickname: "혜린"
      ),
      Member(
        id: 1,
        nickname: "현아"
      ),
      Member(
        id: 2,
        nickname: "준혁"
      )
    ]
  }
}
