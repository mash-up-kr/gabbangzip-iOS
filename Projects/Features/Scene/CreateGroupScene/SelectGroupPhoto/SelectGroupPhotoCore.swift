//
//  SelectGroupPhotoCore.swift
//  CreateGroup
//
//  Created by YangJoonHyeok on 7/9/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import ComposableArchitecture
import DesignSystem
import Models
import UIKit.UIImage

@Reducer
public struct SelectGroupPhotoCore {
  public init() {}
  
  @ObservableState
  public struct State: Equatable {
    var groupName: String
    var nextButtonType: ButtonType
    var keyword: GroupData.Keyword
    var selectedImages: [UIImage]

    public init(
      groupName: String,
      nextButtonType: ButtonType = .inactive,
      keyword: GroupData.Keyword,
      selectedImages: [UIImage] = []
      
    ) {
      self.groupName = groupName
      self.nextButtonType = nextButtonType
      self.keyword = keyword
      self.selectedImages = selectedImages
    }
  }

  public enum Action {
    // View Action
    case nextButtonTapped
    case selectedImagesChanged([UIImage])
    case backButtonTapped
    
    // Internal Action
    // TODO: - API 요청 구현할 예정
    
    // Route Action
    case moveToCreateGroupCompletion
    case backToSelectKeyword
  }

  public var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .nextButtonTapped:
        return .send(.moveToCreateGroupCompletion)
        
      case let .selectedImagesChanged(images):
        state.selectedImages = images
        if !images.isEmpty {
          state.nextButtonType = .active
        }
        return .none
        
      case .backButtonTapped:
        return .send(.backToSelectKeyword)
        
      case .moveToCreateGroupCompletion:
        return .none
        
      case .backToSelectKeyword:
        return .none
      }
    }
  }
}
