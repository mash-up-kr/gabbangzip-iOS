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
  
  // MARK: - View cornerRadius
  func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
    clipShape(RoundCorners(radius: radius, corners: corners))
  }
}

fileprivate struct RoundCorners: Shape {
  var radius: CGFloat = 10
  var corners: UIRectCorner = .allCorners
  
  func path(in rect: CGRect) -> Path {
    let path = UIBezierPath(
      roundedRect: rect,
      byRoundingCorners: corners,
      cornerRadii: CGSize(width: radius, height: radius)
    )
    return Path(path.cgPath)
  }
}
