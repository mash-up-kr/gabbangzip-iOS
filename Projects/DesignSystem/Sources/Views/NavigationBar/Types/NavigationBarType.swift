//
//  NavigationBarType.swift
//  DesignSystem
//
//  Created by GREEN on 6/25/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import SwiftUI

// MARK: - 네비게이션 바 타입
public enum NavigationBarType {
  // Back 버튼 + 타이틀 조합
  case titleWithBackButton(String)
  // 타이틀
  case title(String)
  // 로고 + 아이콘 조합
  case logoAndTwoIcon(Image, Image)
  // Back 버튼 + 타이틀 + 아이콘 조합
  case titleWithBackButtonAndIcon(String, Image)
}
