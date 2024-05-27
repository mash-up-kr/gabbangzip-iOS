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
  public static let apiClient = APIClient(
    configuration: .init(
      baseURL: URL(
        string: ""
      ),
      delegate: GabbangzipAPIClientDelegate()
    )
  )
}
