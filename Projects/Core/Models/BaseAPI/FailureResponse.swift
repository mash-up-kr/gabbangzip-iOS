//
//  FailureResponse.swift
//  Models
//
//  Created by YangJoonHyeok on 7/7/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

public struct FailureResponse: Decodable {
  public let isSuccess: Bool
  public let errorResponse: ErrorResponse
  
  public init(isSuccess: Bool, errorResponse: ErrorResponse) {
    self.isSuccess = isSuccess
    self.errorResponse = errorResponse
  }
  
  public enum CodingKeys: String, CodingKey {
    case isSuccess = "is_success"
    case errorResponse = "error_response"
  }
}
