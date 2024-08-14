//
//  VoteCompleteCore.swift
//  GroupDetail
//
//  Created by 최혜린 on 7/6/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import ComposableArchitecture
import Models

@Reducer
public struct VoteCompleteCore {
  public init() {}
  
  @ObservableState
  public struct State: Equatable {
    var voteResult: VoteCompleteInfo
    var imageURLString: String

    public init(
      voteResult: VoteCompleteInfo,
      imageURLString: String = ""
    ) {
      self.voteResult = voteResult
      self.imageURLString = imageURLString
    }
  }
  
  @Dependency(\.bundleClient) var bundleClient

  public enum Action {
    // View Action
    case onAppear
    case completeButtonTapped
    
    // Internal Action
    case setImageURLString(String)
    
    // Route Action
    case backToGroupDetail
  }

  public var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .onAppear:
        return .run { [state] send in
          if let s3BucketDomain = try? bundleClient.getValue("S3BucketDomain") as? String {
            let imageURLString = s3BucketDomain + state.voteResult.imageURL
            await send(.setImageURLString(imageURLString))
          }
        }
      case .completeButtonTapped:
        return .send(.backToGroupDetail)
        
      case let .setImageURLString(imageURLString):
        state.imageURLString = imageURLString
        return .none
        
      case .backToGroupDetail:
        return .none
      }
    }
  }
}
