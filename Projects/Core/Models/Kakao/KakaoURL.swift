//
//  LoginAPI.swift
//  CoreKit
//
//  Created by Hyun A Song on 6/22/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

public enum KakaoURL {
  case login
}

extension KakaoURL {
  public var scheme: String {
    switch self {
    case .login:
      return "http"
    }
  }
  
  public var host: String {
    switch self {
    case .login:
      return "3.39.133.214:8080"
    }
  }
  
  public var path: String {
    switch self {
    case .login:
      return "/api/v1/auth/login"
    }
  }
}
