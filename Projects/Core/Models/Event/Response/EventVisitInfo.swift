//
//  EventVisitInfo.swift
//  Models
//
//  Created by hyerin on 8/7/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

public struct EventVisitInfo: Decodable {
  public var visited: Bool
  
  public static var mock: EventVisitInfo = .init(
    visited: true
  )
}
