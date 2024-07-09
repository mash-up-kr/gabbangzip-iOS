//
//  ErrorResponse.swift
//  CoreKit
//
//  Created by Hyun A Song on 6/29/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

public struct ErrorResponse: Decodable {
  public let code: String
  public let message: String
  
  public init(code: String, message: String) {
    self.code = code
    self.message = message
  }
}
