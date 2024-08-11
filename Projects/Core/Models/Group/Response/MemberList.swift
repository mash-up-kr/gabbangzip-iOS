//
//  MemberList.swift
//  Models
//
//  Created by hyerin on 8/8/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import Foundation

public struct MemberList: Decodable, Hashable {
  public let members: [Member]
  public let invitationCode: String

  enum CodingKeys: String, CodingKey {
    case members
    case invitationCode = "invitation_code"
  }
  
  public static var mock: MemberList = .init(
    members: Member.mockList,
    invitationCode: "TESTCODE"
  )
}

// MARK: - Member
public struct Member: Decodable, Hashable {
  public let id: Int
  public let nickname: String
  
  public static let mock: Member = .init(id: 0, nickname: "혜린")
  public static let mockList: [Member] = [
    Member(id: 0, nickname: "혜린"),
    Member(id: 1, nickname: "현아"),
    Member(id: 2, nickname: "준혁")
  ]
}
