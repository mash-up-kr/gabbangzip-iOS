//
//  GetHelpers.swift
//  Services
//
//  Created by YangJoonHyeok on 5/25/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import Foundation
import Get

extension Request {
  public init(route: RouteType) {
    self.init(
      path: route.path,
      method: route.method,
      query: route.query,
      body: route.body,
      headers: route.headers
    )
  }
}
