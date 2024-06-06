//
//  ContentView.swift
//  App
//
//  Created by gabbangzip on 5/20/24.
//

import DesignSystem
import SwiftUI

public struct ContentView: View {
  public init() {}
  
  public var body: some View {
    VStack {
      /// 이렇게 어떤 모듈에서든 편하게 사용할 수 있음
      LottieView(type: .confetti)
        .frame(width: 500, height: 500)
      
      LottieTestView(named: JSONFiles.Bookmark.name)
        .frame(width: 500, height: 500)
    }
  }
}

#Preview {
  ContentView()
}
