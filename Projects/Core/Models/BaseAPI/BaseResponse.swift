//
//  BaseResponse.swift
//  Models
//
//  Created by Hyun A Song on 7/3/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

public struct BaseResponse<T>: Decodable where T: Decodable {
  public let isSuccess: Bool
  public let data: T
  public let errorResponse: BaseErrorResponse?
  
  public init(isSuccess: Bool, data: T, errorResponse: BaseErrorResponse?) {
    self.isSuccess = isSuccess
    self.data = data
    self.errorResponse = errorResponse
  }
  
  public enum CodingKeys: String, CodingKey {
    case isSuccess = "is_success"
    case data
    case errorResponse = "error_response"
  }
}
