//
//  KakaoResponse.swift
//  Models
//
//  Created by Hyun A Song on 6/22/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

public struct KakaoResponse: Decodable {
  public let isSuccess: Bool
  public let data: PICUserInformation?
  public let errorResponse: KakaoErrorResponse?
}
