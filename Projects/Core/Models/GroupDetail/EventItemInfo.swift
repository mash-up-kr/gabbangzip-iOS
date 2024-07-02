//
//  PIC.swift
//  Models
//
//  Created by 최혜린 on 6/29/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import Foundation

public struct EventItemInfo: Equatable, Identifiable {
  public var id = UUID()
  
  public let title: String
  // TODO: 추후 View 타입으로 변경되지 않을까 예상 중 입니다... 서버에서 받은 값으로 만든 thumbnailView
  public let imageURL: URL?
  public let date: String
  
  public init(
    title: String,
    imageURL: URL?,
    date: String
  ) {
    self.title = title
    self.imageURL = imageURL
    self.date = date
  }
  
  public static var mock: EventItemInfo {
    EventItemInfo(
      title: "가빵 JMT🚀",
      imageURL: URL(string: "https://24ai.tech/ru/wp-content/uploads/sites/4/2023/10/01_product_1_sdelat-kvadratnym-scaled.jpg"),
      date: "2024.06.01"
    )
  }
}
