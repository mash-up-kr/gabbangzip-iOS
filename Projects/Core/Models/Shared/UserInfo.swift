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
  
  public init(userID: Int, nickname: String, accessToken: String, refreshToken: String) {
    self.userID = userID
    self.nickname = nickname
    self.accessToken = accessToken
    self.refreshToken = refreshToken
  }
  
  public mutating func update<T>(keyPath: WritableKeyPath<UserInfo, T>, value: T) {
    self[keyPath: keyPath] = value
  }
  
  public static let defaultValue = UserInfo(userID: -1, nickname: "", accessToken: "", refreshToken: "")
}
