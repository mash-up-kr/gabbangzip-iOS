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
  
  public static var mock: [Member] {
    [
      Member(
        name: "혜린",
        imageURL: URL(string: "https://thumbnews.nateimg.co.kr/view610///news.nateimg.co.kr/orgImg/ts/2024/05/31/15501274_1325007_402_org.jpg")!,
        isLeader: true
      ),
      Member(
        name: "현아",
        imageURL: URL(string: "https://thumbnews.nateimg.co.kr/view610///news.nateimg.co.kr/orgImg/ts/2024/05/31/15501274_1325007_402_org.jpg")!,
        isLeader: false
      ),
      Member(
        name: "준혁",
        imageURL: URL(string: "https://thumbnews.nateimg.co.kr/view610///news.nateimg.co.kr/orgImg/ts/2023/08/25/15386262_1166181_4957_org.jpg")!,
        isLeader: false
      )
    ]
  }
}

public typealias MemberList = [Member]
