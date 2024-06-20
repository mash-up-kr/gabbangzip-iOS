//
//  RouteType.swift
//  Services
//
//  Created by YangJoonHyeok on 5/26/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import Foundation
import Get

public protocol RouteType {
  /// The path to be appended to `baseURL` to form the full `URL`.
  var path: String { get }
  
  /// The query parameters to be appended to the URL as key-value pairs.
  /// Each tuple contains a key and an optional value.
  /// If the value is `nil`, the key will be present without a value.
  var query: [(String, String?)]? { get }

  /// The HTTP method used in the request.
  var method: HTTPMethod { get }
  
  /// The body data for the request.
  var body: Encodable? { get }

  /// The headers to be used in the request.
  var headers: [String: String]? { get }
}
