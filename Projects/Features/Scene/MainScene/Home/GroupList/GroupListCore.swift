//
//  GroupListCore.swift
//  Main
//
//  Created by YangJoonHyeok on 9/25/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import ComposableArchitecture
import DesignSystem
import Models
import Services

@Reducer
public struct GroupListCore {
  public init() {}

  @ObservableState
  public struct State: Equatable {
    var groups: IdentifiedArrayOf<GroupCore.State>
    
    public init(
      groups: IdentifiedArrayOf<GroupCore.State> = []
    ) {
      self.groups = groups
    }
  }

  public enum Action {
    // View Action
    // Internal Action
    // Child Action
    case groups(IdentifiedActionOf<GroupCore>)
    // Delegate
    case delegate(Delegate)
    
    public enum Delegate {
      case moveToGroupDetail(Int)
      case moveToCreateEvent(Int)
      case showToastMessage(ToastType)
      case fetchGroups
      case moveToVote(Int)
    }
  }

  public var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case let .groups(.element(id: _, action: .delegate(delegate))):
        return .run { send in
          switch delegate {
          case let .headerButtonTapped(groupID):
            await send(.delegate(.moveToGroupDetail(groupID)))
          case let .createEventButtonTapped(groupID):
            await send(.delegate(.moveToCreateEvent(groupID)))
          case .stabbingSuccessed:
            await send(.delegate(.showToastMessage(.textWithCheckIcon("쿡찌르기 성공!"))))
          case .stabbingFailed:
            await send(.delegate(.showToastMessage(.textWithInfoIcon("쿡찌르기 실패!"))))
          case .imageUploadSuccessed:
            await send(.delegate(.showToastMessage(.textWithCheckIcon("이미지 업로드 성공!"))))
            await send(.delegate(.fetchGroups))
          case .imageUploadFailed:
            await send(.delegate(.showToastMessage(.textWithInfoIcon("이미지 업로드 실패!"))))
          case let .selectPICButtonTapped(eventID):
            await send(.delegate(.moveToVote(eventID)))
          }
        }
        
      case .groups:
        return .none
        
      case .delegate:
        return .none
      }
    }
    .forEach(\.groups, action: \.groups) {
      GroupCore()
    }
  }
}
