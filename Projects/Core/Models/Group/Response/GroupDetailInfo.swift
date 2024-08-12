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
  public let recentEventDetail: RecentEventDetail
  public let cardFrontImageURL: String
  public let cardBackImages: [CardBackImage]
  public let history: [History]

  enum CodingKeys: String, CodingKey {
    case id, name, keyword, status
    case statusDescription = "status_description"
    case recentEventDetail = "recent_event"
    case cardFrontImageURL = "card_front_image_url"
    case cardBackImages = "card_back_images"
    case history
  }
  
  public static let noHistorymock: GroupDetailInfo = .init(
    id: 0,
    name: "뛰뛰빵빵 가빵집🍞",
    keyword: .crew,
    status: .beforeMyUpload,
    statusDescription: "모든 그룹원이 사진을 올리면 투표가 시작돼요",
    recentEventDetail: .mock,
    cardFrontImageURL: "https://24ai.tech/ru/wp-content/uploads/sites/4/2023/10/01_product_1_sdelat-kvadratnym-scaled.jpg",
    cardBackImages: [],
    history: []
  )
  
  public static let historymock: GroupDetailInfo = .init(
    id: 0,
    name: "뛰뛰빵빵 가빵집🍞",
    keyword: .crew,
    status: .eventCompleted,
    statusDescription: "모든 그룹원이 사진을 올리면 투표가 시작돼요",
    recentEventDetail: .mock,
    cardFrontImageURL: "https://24ai.tech/ru/wp-content/uploads/sites/4/2023/10/01_product_1_sdelat-kvadratnym-scaled.jpg",
    cardBackImages: [],
    history: History.listMomck
  )
  
  public init(
    id: Int,
    name: String,
    keyword: GroupData.Keyword,
    status: GroupData.Status,
    statusDescription: String,
    recentEventDetail: RecentEventDetail,
    cardFrontImageURL: String,
    cardBackImages: [CardBackImage],
    history: [History]
  ) {
    self.id = id
    self.name = name
    self.keyword = keyword
    self.status = status
    self.statusDescription = statusDescription
    self.recentEventDetail = recentEventDetail
    self.cardFrontImageURL = cardFrontImageURL
    self.cardBackImages = cardBackImages
    self.history = history
  }
}

extension GroupDetailInfo: Equatable {
  public static func == (lhs: GroupDetailInfo, rhs: GroupDetailInfo) -> Bool {
    lhs.id == rhs.id
  }
}

public struct History: Decodable, Identifiable, Equatable {
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
  
  public static let listMomck: [History] = [
    .init(
      id: 0,
      name: "모임 이름1",
      date: "2024.06.01",
      images: [.mock]
    ),
    .init(
      id: 1,
      name: "모임 이름1",
      date: "2024.06.01",
      images: [.mock]
    ),
    .init(
      id: 2,
      name: "모임 이름1",
      date: "2024.06.01",
      images: [.mock]
    ),
    .init(
      id: 3,
      name: "모임 이름1",
      date: "2024.06.01",
      images: [.mock]
    ),
    .init(
      id: 4,
      name: "모임 이름1",
      date: "2024.06.01",
      images: [.mock]
    ),
    .init(
      id: 5,
      name: "모임 이름1",
      date: "2024.06.01",
      images: [.mock]
    ),
    .init(
      id: 6,
      name: "모임 이름1",
      date: "2024.06.01",
      images: [.mock]
    )
  ]
}

public struct RecentEventDetail: Codable {
  public let id: Int
  public let name: String
  public let date: String
  public let deadline: String
  
  public static let mock: RecentEventDetail = .init(
    id: 0,
    name: "가빵집 MT",
    date: "2024.11.03",
    deadline: "6월 14일 월요일 12시 37분"
  )
}
