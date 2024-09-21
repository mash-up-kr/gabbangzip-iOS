//
//  CreateGroupCompletionCore.swift
//  CreateGroup
//
//  Created by YangJoonHyeok on 8/1/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import Common
import ComposableArchitecture
import DesignSystem
import Models
import Services

@Reducer
public struct CreateGroupCompletionCore {
  public init() {}

  @ObservableState
  public struct State: Equatable {
    var createdGroupInfo: CreatedGroupInfo
    var imageURLString: String
    var toastPresented: Bool
    var isFromGetStarted: Bool
    
    public init(
      createdGroupInfo: CreatedGroupInfo,
      imageURLString: String = "",
      toastPresented: Bool = false,
      isFromGetStarted: Bool
    ) {
      self.createdGroupInfo = createdGroupInfo
      self.imageURLString = imageURLString
      self.toastPresented = toastPresented
      self.isFromGetStarted = isFromGetStarted
    }
  }

  public enum Action {
    // View Action
    case onAppear
    case completeButtonTapped
    case copyLinkButtonTapped
    
    // Internal Action
    case setImageURLString(String)
    case setToastPresented(Bool)
    
    // Route Action
    case backToHome
    case goToHome
  }
  
  @Dependency(\.bundleClient) var bundleClient
  @Dependency(\.uiPasteBoardClient) var uiPasteBoardClient

  public var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .onAppear:
        return .run { [state] send in
          if let s3BucketDomain = try? bundleClient.getValue("S3BucketDomain") as? String {
            let imageURLString = s3BucketDomain + state.createdGroupInfo.groupImageURL
            await send(.setImageURLString(imageURLString))
          }
        }
      
      case .completeButtonTapped:
        return .send(state.isFromGetStarted ? .goToHome : .backToHome)
        
      case .copyLinkButtonTapped:
        state.toastPresented = true
        
        return .run { [state] send in
          uiPasteBoardClient.copyTextToClipboard(
            """
            PIC 앱 다운받기
            - PlayStore: https://play.google.com/store/apps/details?id=com.mashup.gabbangzip.sharedalbum
            - AppStore: https://apps.apple.com/kr/app/PIC/id6503334452
            초대코드: \(state.createdGroupInfo.invitationCode)
            """
          )
        }
        
      case let .setImageURLString(urlString):
        state.imageURLString = urlString
        return .none
        
      case let .setToastPresented(isPresented):
        state.toastPresented = isPresented
        return .none
        
      case .backToHome:
        return .none
        
      case .goToHome:
        return .none
      }
    }
  }
}
