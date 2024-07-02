//
//  TokenResponse.swift
//  Models
//
//  Created by Hyun A Song on 6/30/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

public struct TokenResponse: Decodable {
  public let isSuccess: Bool
  public let data: TokenInformation?
  public let errorResponse: APIErrorResponse?
  
  public enum CodingKeys: String, CodingKey {
    case isSuccess = "is_success"
    case data
    case errorResponse = "error_response"
  }
}
