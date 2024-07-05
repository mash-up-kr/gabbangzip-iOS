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
  public enum Keyword: Decodable, Hashable {
    case school
    case company
    case crew
    case network
    case exercise
    case hobby
    case littleMoim
    
    public init(from decoder: Decoder) throws {
      let container = try decoder.singleValueContainer()
      let rawValue = try container.decode(String.self)
      switch rawValue {
      case "SCHOOL":
        self = .school
      case "COMPANY":
        self = .company
      case "CREW":
        self = .crew
      case "NETWORK":
        self = .network
      case "EXERCISE":
        self = .exercise
      case "HOBBY":
        self = .hobby
      case "LITTME_MOIM":
        self = .littleMoim
      default:
        throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid keyword value")
      }
    }
  }
  
  public enum Status: Decodable, Hashable {
    case noPastAndCurrentEvent
    case noCurrentEvent
    case beforeMyUpload
    case afterMyUpload
    case beforeMyVote
    case afterMyVote
    case eventCompleted

    public init(from decoder: Decoder) throws {
      let container = try decoder.singleValueContainer()
      let rawValue = try container.decode(String.self)
      switch rawValue {
      case "NO_PAST_AND_CURRENT_EVENT":
        self = .noPastAndCurrentEvent
      case "NO_CURRENT_EVENT":
        self = .noCurrentEvent
      case "BEFORE_MY_UPLOAD":
        self = .beforeMyUpload
      case "AFTER_MY_UPLOAD":
        self = .afterMyUpload
      case "BEFORE_MY_VOTE":
        self = .beforeMyVote
      case "AFTER_MY_VOTE":
        self = .afterMyVote
      case "EVENT_COMPLETED":
        self = .eventCompleted
      default:
        throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid status value")
      }
    }
  }
}
