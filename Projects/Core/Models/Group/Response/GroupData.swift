//
//  GroupData.swift
//  Models
//
//  Created by YangJoonHyeok on 7/5/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import Foundation

public struct GroupData: Decodable, Equatable {
  public let id: Int
  public let name: String
  public let keyword: Keyword
  public let status: Status
  public let statusDescription: String
  public let recentEvent: RecentEvent
  public let cardFrontImageURL: String
  public let cardBackImages: [CardBackImage]?
  
  enum CodingKeys: String, CodingKey {
    case id, name, keyword, status
    case statusDescription = "status_description"
    case recentEvent = "recent_event"
    case cardFrontImageURL = "card_front_image_url"
    case cardBackImages = "card_back_images"
  }
}

public struct RecentEvent: Decodable, Equatable {
  public let id: Int
  public let name: String?
  public let date: String?
  
  public init(
    id: Int,
    name: String?,
    date: String?
  ) {
    self.id = id
    self.name = name
    self.date = date
  }
}

extension GroupData {
  public enum Keyword: String, CaseIterable, Decodable {
    case school = "SCHOOL"
    case company = "COMPANY"
    case crew = "CREW"
    case network = "NETWORK"
    case exercise = "EXERCISE"
    case hobby = "HOBBY"
    case littleMoim = "LITTLE_MOIM"
  }

  public enum Status: String, Decodable {
    case noPastAndCurrentEvent = "NO_PAST_AND_CURRENT_EVENT"
    case noCurrentEvent = "NO_CURRENT_EVENT"
    case beforeMyUpload = "BEFORE_MY_UPLOAD"
    case afterMyUpload = "AFTER_MY_UPLOAD"
    case beforeMyVote = "BEFORE_MY_VOTE"
    case afterMyVote = "AFTER_MY_VOTE"
    case eventCompleted = "EVENT_COMPLETED"
    
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
}
