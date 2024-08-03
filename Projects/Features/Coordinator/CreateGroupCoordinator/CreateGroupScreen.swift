//
//  CreateGroupScreen.swift
//  CreateGroupCoordinator
//
//  Created by YangJoonHyeok on 7/21/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import ComposableArchitecture
import CreateGroup
import TCACoordinators

@Reducer(state: .equatable)
public enum CreateGroupScreen {
  case createGroupStart(CreateGroupStartCore)
  case setGroupName(SetGroupNameCore)
  case selectKeyword(SelectKeywordCore)
  case selectGroupPhoto(SelectGroupPhotoCore)
  case createGroupCompletion(CreateGroupCompletionCore)
}
