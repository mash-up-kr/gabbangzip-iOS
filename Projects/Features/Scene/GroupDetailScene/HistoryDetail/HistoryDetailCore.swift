//
//  HistoryDetailCore.swift
//  GroupDetail
//
//  Created by 최혜린 on 7/6/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import ComposableArchitecture
import Models

@Reducer
public struct HistoryDetailCore {
  @ObservableState
  public struct State: Equatable {
    var history: History
    var keyword: GroupData.Keyword
    var s3BucketDomain: String
    
    public init(
      history: History,
      keyword: GroupData.Keyword,
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
        return .none
        
      case .backToGroupDetail:
        return .none
      }
    }
  }
}
