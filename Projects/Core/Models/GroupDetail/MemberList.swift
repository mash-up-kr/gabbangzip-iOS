//
//  MemberList.swift
//  CoreKit
//
//  Created by 최혜린 on 6/22/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import Foundation

public struct Member: Equatable, Identifiable {
  public var id = UUID()
  
  public let name: String
  public let isLeader: Bool
  
  public init(
    name: String,
    isLeader: Bool
  ) {
    self.name = name
    self.isLeader = isLeader
  }
  
  public static var leaderMock: Member {
    Member(
      name: "혜린",
      isLeader: true
    )
  }
  
  public static var notLeaderMock: Member {
    Member(
      name: "혜린",
      isLeader: false
    )
  }
  
  public static var mockList: [Member] {
    [
      Member(
        name: "혜린",
        isLeader: true
      ),
      Member(
        name: "현아",
        isLeader: false
      ),
      Member(
        name: "준혁",
        isLeader: false
      )
    ]
  }
}

public typealias MemberList = [Member]
