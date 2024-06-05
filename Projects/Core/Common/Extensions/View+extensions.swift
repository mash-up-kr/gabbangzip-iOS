//
//  View+extensions.swift
//  Common
//
//  Created by GREEN on 6/5/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import SwiftUI

public extension View {
  // MARK: - 특정 뷰 캡쳐
  @MainActor
  func captureView(
    of view: some View,
    scale: CGFloat = 1.0,
    size: CGSize? = nil,
    completion: @escaping (UIImage?) -> Void
  ) {
    let renderer = ImageRenderer(content: view)
    renderer.scale = scale
    
    if let size = size {
      renderer.proposedSize = .init(size)
    }
    
    completion(renderer.uiImage)
  }
}
