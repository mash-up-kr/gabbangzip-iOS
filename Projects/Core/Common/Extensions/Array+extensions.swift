//
//  Array+extensions.swift
//  Common
//
//  Created by GREEN on 6/5/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import Foundation

public extension Array {
  subscript(safe index: Int) -> Element? {
    get {
      indices ~= index ? self[index] : nil
    }
    set(newValue) {
      if let newValue = newValue, indices.contains(index) {
        self[index] = newValue
      }
    }
  }
}
