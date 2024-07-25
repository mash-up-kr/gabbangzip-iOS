//
//  MyPageScreen.swift
//  MyPageCoordinator
//
//  Created by YangJoonHyeok on 7/21/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import ComposableArchitecture
import CreateGroup
import MyPage
import TCACoordinators

@Reducer(state: .equatable)
public enum MyPageScreen {
  case myPage(MyPageCore)
}
