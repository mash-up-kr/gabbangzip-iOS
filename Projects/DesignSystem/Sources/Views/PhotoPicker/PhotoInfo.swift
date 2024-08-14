//
//  PhotoInfo.swift
//  DesignSystem
//
//  Created by YangJoonHyeok on 8/2/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import Foundation

public struct PhotoInfo: Hashable {
  public let data: Data
  public let url: URL
  public var fileExtension: String {
    url.pathExtension
  }
  
  public init(data: Data, url: URL) {
    self.data = data
    self.url = url
  }
}
