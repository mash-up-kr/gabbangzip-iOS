//
//  EventCompletedCore.swift
//  GroupDetail
//
//  Created by hyerin on 8/11/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import ComposableArchitecture
import Models
import SwiftUI
import UIKit

@Reducer
public struct EventCompletedCore {
  public init() {}

  @ObservableState
  public struct State: Equatable {
    var showActivityView: Bool
    var capturedImage: UIImage?
    var keyword: GroupData.Keyword
    var recentEvent: RecentEvent
    var s3BucketDomain: String
    var cardBackImage: [CardBackImage]
    
    public init(
      showActivityView: Bool = false,
      capturedImage: UIImage?,
      keyword: GroupData.Keyword,
      recentEvent: RecentEvent,
      s3BucketDomain: String,
      cardBackImage: [CardBackImage]
    ) {
      self.showActivityView = showActivityView
      self.capturedImage = capturedImage
      self.keyword = keyword
      self.recentEvent = recentEvent
      self.s3BucketDomain = s3BucketDomain
      self.cardBackImage = cardBackImage
    }
  }

  public enum Action: BindableAction {
    case binding(BindingAction<State>)
    
    // View Action
    case shareButtonTapped
    case imageCaptured(UIImage?)
    
    // Internal Action
    
    // Route Action
  }

  public var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .binding:
        return .none
        
      case .shareButtonTapped:
        state.showActivityView = true
        return .none
        
      case let .imageCaptured(image):
        state.capturedImage = image
        return .none
      }
    }
  }
}
