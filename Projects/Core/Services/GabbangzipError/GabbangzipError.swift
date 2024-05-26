//
//  GabbangzipError.swift
//  Services
//
//  Created by YangJoonHyeok on 5/26/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import Foundation

public protocol GabbangzipError: CustomNSError {
  var code: Code { get }
  var userInfo: [String: Any] { get }
  var underlying: Error? { get }
  
  associatedtype Code: RawRepresentable where Code.RawValue == Int
}

extension GabbangzipError {
  public var errorDomain: String { "\(Self.self)" }
  public var errorCode: Int { self.code.rawValue }
  public var errorUserInfo: [String: Any] {
    var userInfo: [String: Any] = self.userInfo
    userInfo["identifier"] = String(reflecting: code)
    userInfo[NSUnderlyingErrorKey] = underlying
    return userInfo
  }
}
