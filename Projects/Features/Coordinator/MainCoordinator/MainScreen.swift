//
//  MainScreen.swift
//  MainCoordinator
//
//  Created by YangJoonHyeok on 7/21/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import ComposableArchitecture
import CreateEvent
import CreateGroupCoordinator
import Main
import MyPage
import TCACoordinators

@Reducer(state: .equatable)
public enum MainScreen {
  case createGroupCoordinator(CreateGroupCoordinatorCore)
  case createEvent(CreateEventCore)
  case myPage(MyPageCore)
  case groupList(GroupListCore)
  case joinGroup(JoinGroupCore)
}
