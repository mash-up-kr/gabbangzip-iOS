//
//  SuccessResponse.swift
//  Models
//
//  Created by Hyun A Song on 7/3/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

public struct SuccessResponse<T>: Decodable where T: Decodable {
  public let isSuccess: Bool
  public let data: T
  
  public init(isSuccess: Bool, data: T) {
    self.isSuccess = isSuccess
    self.data = data
  }
  
  public enum CodingKeys: String, CodingKey {
    case isSuccess = "is_success"
    case data
  }
}
