//
//  GroupData.swift
//  Models
//
//  Created by YangJoonHyeok on 7/5/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import Foundation

public struct GroupData: Decodable, Hashable {
  public let name: String
  public let keyword: Keyword
  public let status: Status
  public let statusDescription: String
  public let recentEventDate: String
  public let cardFrontImageURL: String
  public let cardBackImages: [CardBackImage]
  
  enum CodingKeys: String, CodingKey {
    case name, keyword, status
    case statusDescription = "status_description"
    case recentEventDate = "recent_event_date"
    case cardFrontImageURL = "card_front_image_url"
    case cardBackImages = "card_back_images"
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
  }
}
