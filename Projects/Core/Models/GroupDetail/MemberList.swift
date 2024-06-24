//
//  MemberList.swift
//  CoreKit
//
//  Created by 최혜린 on 6/22/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import Foundation

public struct Member: Equatable {
  public let name: String
  public let imageURL: URL
  public let isLeader: Bool
  
  public init(
    name: String,
    imageURL: URL,
    isLeader: Bool
  ) {
    self.name = name
    self.imageURL = imageURL
    self.isLeader = isLeader
  }
}

public typealias MemberList = [Member]
