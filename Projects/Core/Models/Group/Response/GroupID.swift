//
//  GroupID.swift
//  Models
//
//  Created by YangJoonHyeok on 8/4/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import Foundation

public struct GroupID: Decodable {
  public let groupID: Int
  
  enum CodingKeys: String, CodingKey {
    case groupID = "group_id"
  }
}

extension GroupID {
  public static let mock = Self(groupID: 1)
}
