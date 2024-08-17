//
//  EventInfo.swift
//  Models
//
//  Created by Hyun A Song on 8/16/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

public struct EventInfo: Decodable {
  public let id: Int
  
  public init(id: Int) {
    self.id = id
  }
  
  public static let mock: EventInfo = .init(id: 0)
}
