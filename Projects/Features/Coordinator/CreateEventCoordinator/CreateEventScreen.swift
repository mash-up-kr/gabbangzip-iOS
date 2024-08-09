//
//  CreateEventScreen.swift
//  CreateEventCoordinator
//
//  Created by Hyun A Song on 8/8/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import ComposableArchitecture
import CreateEvent
import GroupDetail
import Main
import TCACoordinators

@Reducer(state: .equatable)
public enum CreateEventScreen {
  case createEventStart(CreateEventStartCore)
  case moveToGroupDetail(GroupListCore)
  case moveToGroupMemberList(MemberListCore)
  case moveToCreateEventProcess(CreateEventProcessCore)
}
