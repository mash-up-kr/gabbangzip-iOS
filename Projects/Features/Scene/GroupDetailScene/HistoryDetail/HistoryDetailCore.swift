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

@Reducer
public struct HistoryDetailCore {
  public init() {}
  
  @ObservableState
  public struct State: Equatable {
    var history: History
    var keyword: GroupData.Keyword?
    var s3BucketDomain: String
    
    var eventDate: String {
      history.date.toGroupEventDateString(type: .eventDate) ?? ""
    }
    
    public init(
      history: History,
      keyword: GroupData.Keyword?,
      s3BucketDomain: String
    ) {
      self.history = history
      self.keyword = keyword
      self.s3BucketDomain = s3BucketDomain
    }
  }

  public enum Action {
    // View Action
    case backButtonTapped
    
    // Route Action
    case backToGroupDetail
  }

  public var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .backButtonTapped:
        return .send(.backToGroupDetail)
        
      case .backToGroupDetail:
        return .none
      }
    }
  }
}
