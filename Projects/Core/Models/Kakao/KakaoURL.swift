//
//  LoginAPI.swift
//  Models
//
//  Created by Hyun A Song on 6/22/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

public enum KakaoURL {
  case login
  case authTest
}

extension KakaoURL {
  public var scheme: String {
    switch self {
    case .login, .authTest:
      return "http"
    }
  }
  
  public var host: String {
    switch self {
    case .login, .authTest:
      return "3.39.133.214"
    }
  }
  
  public var path: String {
    switch self {
    case .login:
      return "/api/v1/auth/login"
    case .authTest:
      return "/api/v1/auth/me-test"
    }
  }
  
  public var port: Int? {
    switch self {
    case .login, .authTest:
      return 8080
    }
  }
}
