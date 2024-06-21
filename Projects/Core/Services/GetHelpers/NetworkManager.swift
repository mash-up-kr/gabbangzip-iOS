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
  
  // !!!: Change the base URL before using
  public static let shared = APIClient(
    configuration: .init(
      baseURL: URL(
        string: ""
      ),
      delegate: GabbangzipAPIClientDelegate()
    )
  )
}
