//
//  NetworkManager.swift
//  Services
//
//  Created by YangJoonHyeok on 5/27/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import Foundation
import Get

public struct NetworkManager {
  private init() {}
  
  public static let shared = APIClient(
    configuration: .init(
      baseURL: URL(
        string: "http://ec2-43-203-14-157.ap-northeast-2.compute.amazonaws.com"
      ),
      delegate: GabbangzipAPIClientDelegate()
    )
  )
}

public struct AppleNetworkManager {
  private init() {}
  
  public static let shared = APIClient(
    configuration: .init(
      baseURL: URL(
        string: "https://appleid.apple.com"
      ),
      delegate: GabbangzipAPIClientDelegate()
    )
  )
}
