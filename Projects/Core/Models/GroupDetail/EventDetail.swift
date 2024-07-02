//
//  EventDetail.swift
//  Models
//
//  Created by 최혜린 on 6/29/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import Foundation

public struct EventDetail: Equatable {
  public let state: EventState
  public let date: String
  public let name: String
  public let dueTime: String
  public let dueDate: String
  public let imageURL: URL
  
  public init(
    state: EventState,
    date: String,
    name: String,
    dueTime: String,
    dueDate: String,
    imageURL: URL
  ) {
    self.state = state
    self.date = date
    self.name = name
    self.dueTime = dueTime
    self.dueDate = dueDate
    self.imageURL = imageURL
  }
  
  public static func mock(state: EventState) -> EventDetail {
    EventDetail(
      state: state,
      date: "2024년 6월 10일",
      name: "가빵 회식🍀",
      dueTime: "03:20",
      dueDate: "6월 14일 월요일",
      imageURL: URL(string: "https://24ai.tech/ru/wp-content/uploads/sites/4/2023/10/01_product_1_sdelat-kvadratnym-scaled.jpg")!
    )
  }
}

public enum EventState {
  // 역대 이벤트 x, 현재 이벤트 o
  case noPastAndCurrentEvent
  // 역대 이벤트 o, 현재 진행 중 이벤트 x
  case noCurrentEvent
  case beforeMyUpload
  case afterMyUpload
  case beforeMyVote
  case afterMyVote
  case eventCompleted
  
  public func message(time: String) -> String? {
    switch self {
    case .noPastAndCurrentEvent, .noCurrentEvent, .eventCompleted:
      return nil
    case .beforeMyUpload:
      return "\(time)까지 내 PIC 등록을 완료해 주세요."
    case .afterMyUpload:
      return "아직 사진 추가를 하지 않은 친구가 있어요!"
    case .beforeMyVote:
      return "내 PIC을 고르고 네컷사진을 완성해 보세요."
    case .afterMyVote:
      return "아직 PIC을 고르지 않은 친구가 있어요!"
    }
  }
}
