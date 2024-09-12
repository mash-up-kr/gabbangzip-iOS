//
//  UserInfo.swift
//  Models
//
//  Created by YangJoonHyeok on 7/21/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

public struct UserInfo: Codable, Equatable {
  public var userID: Int
  public var nickname: String
  public var accessToken: String
  public var refreshToken: String
  public var loginType: LoginType
  
  public init(
    userID: Int,
    nickname: String,
    accessToken: String,
    refreshToken: String,
    loginType: LoginType
  ) {
    self.userID = userID
    self.nickname = nickname
    self.accessToken = accessToken
    self.refreshToken = refreshToken
    self.loginType = loginType
  }
  
  public mutating func update<T>(keyPath: WritableKeyPath<UserInfo, T>, value: T) {
    self[keyPath: keyPath] = value
  }
  
  public static let defaultValue = UserInfo(userID: -1, nickname: "", accessToken: "", refreshToken: "", loginType: .kakao)
  
  public enum LoginType: String, Codable {
    case kakao
    case apple
  }
}
