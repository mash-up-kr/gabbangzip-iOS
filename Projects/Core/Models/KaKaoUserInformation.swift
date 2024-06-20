//
//  KaKaoUserInformation.swift
//  Models
//
//  Created by Hyun A Song on 6/19/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import Foundation

public struct KaKaoUserInformation: Decodable {
  public let idToken: String?
  public let nickName: String?
  public let profileImageUrl: URL?
}
