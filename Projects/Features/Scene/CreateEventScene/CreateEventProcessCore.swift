//
//  CreateEventCore.swift
//  CreateEvent
//
//  Created by Hyun A Song on 8/8/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import Common
import ComposableArchitecture
import DesignSystem
import Foundation
import Models
import Services

@Reducer
public struct CreateEventCore {
  public init() {}
  
  @ObservableState
  public struct State: Equatable {
    public var text: String
    public var isExiting: Bool
    public var isEventNamed: Bool
    public var isPhotoSelected: Bool
    public var completeButtonType: ButtonType
    public var recentEvent: RecentEvent
    public var selectedPhotosInfo: [PhotoInfo]
    public var recentEventDate: String {
      return recentEvent.date?.toCreateEventDateString() ?? ""
    }
    
    public init(
      text: String = "",
      isExiting: Bool = false,
      isEventNamed: Bool = false,
      isPhotoSelected: Bool = false,
      completeButtonType: ButtonType = .inactive,
      recentEvent: RecentEvent,
      selectedPhotosInfo: [PhotoInfo] = []
    ) {
      self.text = text
      self.isExiting = isExiting
      self.isEventNamed = isEventNamed
      self.isPhotoSelected = isPhotoSelected
      self.completeButtonType = completeButtonType
      self.recentEvent = recentEvent
      self.selectedPhotosInfo = selectedPhotosInfo
    }
  }
  
  public enum Action: BindableAction {
    case binding(BindingAction<State>)
    
    // View Action
    case textChanged(String)
    case selectedImagesChanged([PhotoInfo])
    case backButtonTapped
    case popupLeftButtonTapped
    case popupRightButtonTapped
    case completeButtonTapped
    case deleteSelectedPhoto(Int)
    
    // Internal Action
    case changeIsEventNamedStatus(Bool)
    case changeIsPhotoSelected
    case checkCompleteButtonType
    
    // Route Action
    case moveToEventStart
    case moveToGroupListWithEvent
  }
  
  @Dependency(\.bundleClient) var bundleClient
  @Dependency(\.uiPasteBoardClient) var uiPasteBoardClient
  
  public var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .binding:
        return .none
        
      case let .textChanged(text):
        state.text = text
        
        return .run { [state] send in
          await send(.changeIsEventNamedStatus(state.text.isEmpty))
        }
        
      case let .selectedImagesChanged(imagesData):
        state.selectedPhotosInfo = imagesData
        return .run { send in
          await send(.changeIsPhotoSelected)
        }
        
      case .backButtonTapped:
        state.isExiting = true
        return .none
        
      case .popupLeftButtonTapped:
        return .run { send in
          await send(.moveToEventStart)
        }
        
      case .popupRightButtonTapped:
        state.isExiting = false
        return .none
        
      case .completeButtonTapped:
        return .run { send in
          await send(.moveToGroupListWithEvent)
        }
        
      case let .deleteSelectedPhoto(index):
        state.selectedPhotosInfo.remove(at: index)
        return .run { send in
          await send(.changeIsPhotoSelected)
        }
        
      case let .changeIsEventNamedStatus(status):
        state.isEventNamed = status
        return .run { send in
          await send(.checkCompleteButtonType)
        }
        
      case .changeIsPhotoSelected:
        state.isPhotoSelected = state.selectedPhotosInfo.count == 4 ? true : false
        return .run { send in
          await send(.checkCompleteButtonType)
        }
        
      case .checkCompleteButtonType:
        if state.isEventNamed && state.isPhotoSelected {
          state.completeButtonType = .active
        } else {
          state.completeButtonType = .inactive
        }
        return .none
        
      case .moveToEventStart:
        return .none
        
      case .moveToGroupListWithEvent:
        return .none
      }
    }
  }
}
