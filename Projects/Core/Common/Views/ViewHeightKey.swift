//
//  ViewHeightKey.swift
//  Common
//
//  Created by 최혜린 on 7/4/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import SwiftUI

public struct ViewHeightKey: PreferenceKey {
  public static var defaultValue: CGFloat = .zero
  public static func reduce(
    value: inout CGFloat,
    nextValue: () -> CGFloat
  ) {
    value = nextValue()
  }
}

public struct ViewHeightGeometry: View {
  public init() {}
  
  public var body: some View {
    GeometryReader { geometry in
      Color.clear
        .preference(
          key: ViewHeightKey.self,
          // TODO: UIScreen 사용하지 않는 방향으로 개선 예정
          value: geometry.size.height
        )
    }
  }
}
