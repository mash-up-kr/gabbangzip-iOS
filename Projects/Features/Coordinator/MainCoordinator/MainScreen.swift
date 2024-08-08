//
//  MainScreen.swift
//  MainCoordinator
//
//  Created by YangJoonHyeok on 7/21/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import ComposableArchitecture
import CreateEventCoordinator
import CreateGroupCoordinator
import GroupDetailCoordinator
import Main
import MyPage
import TCACoordinators

@Reducer(state: .equatable)
public enum MainScreen {
  case createGroupCoordinator(CreateGroupCoordinatorCore)
  case myPage(MyPageCore)
  case home(HomeCore)
  case joinGroup(JoinGroupCore)
  case groupDetailCoordinator(GroupDetailCoordinatorCore)
}
