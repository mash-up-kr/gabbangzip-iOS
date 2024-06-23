//
//  URLComponents+extensions.swift
//  Common
//
//  Created by Hyun A Song on 6/22/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import Foundation

public extension URLComponents {
  static func createURL(scheme: String, host: String, path: String, port: Int? = nil) -> URL {
    var components = URLComponents()
    components.scheme = scheme
    
    if let port = port {
        components.host = host
        components.port = port
    } else {
        components.host = host
    }
    
    components.path = path
    
    guard let url = components.url else {
      fatalError("Invalid URL components: \(components)")
    }
    
    return url
  }
}
