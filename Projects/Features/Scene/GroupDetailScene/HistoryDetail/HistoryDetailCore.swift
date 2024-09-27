//
//  HistoryDetailCore.swift
//  GroupDetail
//
//  Created by 최혜린 on 7/6/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import ComposableArchitecture
import Foundation
import Models
import UIKit

@Reducer
public struct HistoryDetailCore {
  public init() {}
  
  @ObservableState
  public struct State: Equatable {
    var history: History
    var keyword: GroupData.Keyword?
    var s3BucketDomain: String
    var showActivityView: Bool
    var capturedImage: UIImage?
    
    var eventDate: String {
      history.date.toGroupEventDateString(type: .eventDate) ?? ""
    }
    
    public init(
      history: History,
      keyword: GroupData.Keyword?,
      s3BucketDomain: String,
      showActivityView: Bool = false,
      capturedImage: UIImage? = nil
    ) {
      self.history = history
      self.keyword = keyword
      self.s3BucketDomain = s3BucketDomain
      self.showActivityView = showActivityView
      self.capturedImage = capturedImage
    }
  }

  public enum Action: BindableAction {
    case binding(BindingAction<State>)
    
    // View Action
    case backButtonTapped
    case shareButtonTapped
    
    //
    case imageCaptured(UIImage?)
    
    // Route Action
    case backToGroupDetail
  }

  public var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .binding:
        return .none
        
      case .backButtonTapped:
        return .send(.backToGroupDetail)
        
      case .shareButtonTapped:
        state.showActivityView = true
        return .none
        
      case let .imageCaptured(image):
        state.capturedImage = image
        return .none
        
      case .backToGroupDetail:
        return .none
      }
    }
  }
}
