//
//  NetworkManager.swift
//  CoreKit
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
        string: ""
      ),
      delegate: GabbangzipAPIClientDelegate()
    )
  )
}
