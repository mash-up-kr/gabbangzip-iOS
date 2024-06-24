//
//  KakaoResponseError.swift
//  Models
//
//  Created by Hyun A Song on 6/24/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

public struct KakaoResponseError: Decodable {
  public let code: String
  public let message: String
}
