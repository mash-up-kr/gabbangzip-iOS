//
//  VoteCompleteInfo.swift
//  Models
//
//  Created by hyerin on 8/3/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

public struct VoteCompleteInfo: Decodable, Equatable {
  public var eventID: Int
  public var keyword: GroupData.Keyword
  public var imageURL: String
  
  enum CodingKeys: String, CodingKey {
    case eventID = "event_id"
    case keyword = "group_keyword"
    case imageURL = "random_image_url"
  }
  
  public static let mock: VoteCompleteInfo = .init(
    eventID: 0,
    keyword: .hobby,
    imageURL: "pic/9c8f3f24-6ed2-4a2e-8af5-52aeff93b230.jpeg"
  )
}
