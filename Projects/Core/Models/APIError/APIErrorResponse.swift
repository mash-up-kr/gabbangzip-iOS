//
//  APIErrorResponse.swift
//  CoreKit
//
//  Created by Hyun A Song on 6/29/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

public struct APIErrorResponse: Decodable {
  public let code: String
  public let message: String
}
