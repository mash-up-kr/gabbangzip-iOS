//
//  CreatedGroupInfo.swift
//  Models
//
//  Created by YangJoonHyeok on 8/1/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import Foundation

public struct CreatedGroupInfo: Decodable, Equatable {
  public let id: Int
  public let groupName: String
  public let keyword: GroupData.Keyword
  public let groupImageURL: String
  public let invitationCode: String
  
  public init(
    id: Int,
    groupName: String,
    keyword: GroupData.Keyword,
    groupImageURL: String,
    invitationCode: String
  ) {
    self.id = id
    self.groupName = groupName
    self.keyword = keyword
    self.groupImageURL = groupImageURL
    self.invitationCode = invitationCode
  }
  
  enum CodingKeys: String, CodingKey {
    case id
    case groupName = "group_name"
    case keyword
    case groupImageURL = "group_image_url"
    case invitationCode = "invitation_code"
  }
}
