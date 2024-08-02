//
//  GroupDetailInfo.swift
//  Models
//
//  Created by hyerin on 8/2/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import Foundation

public struct GroupDetailInfo: Decodable {
  public let id: Int
  public let name: String
  public let keyword: GroupData.Keyword
  public let status: GroupData.Status
  public let statusDescription: String
  public let recentEvent: RecentEvent
  public let cardFrontImageURL: String
  public let cardBackImages: [CardBackImage]
  public let history: [History]

  enum CodingKeys: String, CodingKey {
    case id, name, keyword, status
    case statusDescription = "status_description"
    case recentEvent = "recent_event"
    case cardFrontImageURL = "card_front_image_url"
    case cardBackImages = "card_back_images"
    case history
  }
  
  public static var mock: GroupDetailInfo = .init(
    id: 0,
    name: "뛰뛰빵빵 가빵집🍞",
    keyword: .company,
    status: .beforeMyUpload,
    statusDescription: "",
    recentEvent: RecentEvent.mock,
    cardFrontImageURL: "",
    cardBackImages: [],
    history: []
  )
}

extension GroupDetailInfo: Equatable {
  public static func == (lhs: GroupDetailInfo, rhs: GroupDetailInfo) -> Bool {
    lhs.id == rhs.id
  }
}

public struct History: Decodable, Identifiable {
  public let id: Int
  public let name: String
  public let date: String
  public let images: [CardBackImage]
  
  public static let mock: History = .init(
    id: 0,
    name: "모임 이름1",
    date: "2024.06.01",
    images: [.mock]
  )
}

public struct RecentEvent: Codable {
  public let name: String
  public let date: String
  public let deadline: String
  
  public static let mock: RecentEvent = .init(
    name: "",
    date: "",
    deadline: ""
  )
}
