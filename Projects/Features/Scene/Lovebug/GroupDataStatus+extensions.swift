//
//  GroupDataStatus+extensions.swift
//  Lovebug
//
//  Created by YangJoonHyeok on 8/8/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import DesignSystem
import Models

public extension GroupData.Status {
  var smallButtonContentType: SmallButtonContentType? {
    switch self {
    case .beforeMyUpload:
      return .gallery
    case .afterMyUpload, .afterMyVote:
      return .stabbing
    case .beforeMyVote:
      return .vote
    default:
      return nil
    }
  }
  
  var message: String? {
    switch self {
    case .noPastAndCurrentEvent, .noCurrentEvent, .eventCompleted:
      return nil
    case .beforeMyUpload:
      return "모든 그룹원이 사진을 올리면 투표가 시작돼요"
    case .afterMyUpload:
      return "아직 사진 추가를 하지 않은 친구가 있어요"
    case .beforeMyVote:
      return "내 PIC을 고르고 네컷사진을 완성해 보세요"
    case .afterMyVote:
      return "아직 PIC 하지 않은 친구가 있어요"
    }
  }
}
