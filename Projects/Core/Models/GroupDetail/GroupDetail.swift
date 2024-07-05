//
//  GroupDetail.swift
//  Models
//
//  Created by 최혜린 on 6/29/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import Foundation

public struct GroupDetail: Equatable {
  public let eventDetail: EventDetail
  public let groupName: String
  public let eventItems: [EventItemInfo]
  public let category: GroupCategory
  
  public init(
    eventDetail: EventDetail,
    groupName: String,
    eventItems: [EventItemInfo],
    category: GroupCategory
  ) {
    self.eventDetail = eventDetail
    self.groupName = groupName
    self.eventItems = eventItems
    self.category = category
  }
  
  public static var emptyMock: GroupDetail {
    GroupDetail(
      eventDetail: EventDetail.mock(state: .beforeMyUpload),
      groupName: "뛰뛰빵빵 가빵집🍞",
      eventItems: [],
      category: .club
    )
  }
  
  public static var mock: GroupDetail {
    GroupDetail(
      eventDetail: EventDetail.mock(state: .beforeMyUpload),
      groupName: "뛰뛰빵빵 가빵집🍞",
      eventItems: [
        EventItemInfo.mock,
        EventItemInfo.mock,
        EventItemInfo.mock,
        EventItemInfo.mock,
        EventItemInfo.mock,
        EventItemInfo.mock,
        EventItemInfo.mock,
        EventItemInfo.mock,
        EventItemInfo.mock,
        EventItemInfo.mock
      ],
      category: .community
    )
  }
}
