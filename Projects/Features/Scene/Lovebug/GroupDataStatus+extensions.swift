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
}
