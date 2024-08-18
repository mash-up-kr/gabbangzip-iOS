//
//  GroupCore.swift
//  Main
//
//  Created by YangJoonHyeok on 8/8/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import Common
import ComposableArchitecture
import DesignSystem
import Models

@Reducer
public struct GroupCore {
  public init() {}

  @ObservableState
  public struct State: Equatable, Identifiable {
    @Shared var userInfo: UserInfo
    public var id: Int
    var name: String
    var keyword: GroupData.Keyword
    var status: GroupData.Status
    var statusDescription: String
    var recentEvent: RecentEvent
    var cardFrontImageURL: String
    var cardBackImages: [CardBackImage]?
    var isLast: Bool
    var s3BucketDomain: String
    var selectedPhotosInfo: [PhotoInfo]
    var stabbingButtonType: SmallButtonType
    var hasNoEvent: Bool {
      return status == .noPastAndCurrentEvent || status == .noCurrentEvent
    }
    var hasCompletedEvent: Bool {
      return status == .noCurrentEvent || status == .eventCompleted
    }
    var recentEventDate: String {
      return recentEvent.date?.toGroupEventDateString() ?? ""
    }
    var recentEventName: String {
      return recentEvent.name ?? ""
    }
    var frontTitle: String {
      return status == .noPastAndCurrentEvent ? "이벤트를 만들어 보세요!" : recentEventDate
    }

    public init(
      userInfo: Shared<UserInfo>,
      id: Int,
      name: String,
      keyword: GroupData.Keyword,
      status: GroupData.Status,
      statusDescription: String,
      recentEvent: RecentEvent,
      cardFrontImageURL: String,
      cardBackImages: [CardBackImage]?,
      isLast: Bool,
      s3BucketDomain: String = "",
      selectedPhotosInfo: [PhotoInfo] = [],
      stabbingButtonType: SmallButtonType = .active
    ) {
      self._userInfo = userInfo
      self.id = id
      self.name = name
      self.keyword = keyword
      self.status = status
      self.statusDescription = statusDescription
      self.recentEvent = recentEvent
      self.cardFrontImageURL = cardFrontImageURL
      self.cardBackImages = cardBackImages
      self.isLast = isLast
      self.s3BucketDomain = s3BucketDomain
      self.selectedPhotosInfo = selectedPhotosInfo
      self.stabbingButtonType = stabbingButtonType
    }
  }

  public enum Action {
    // Delegate Action
    case delegate(Delegate)
    
    // View Action
    case headerButtonTapped
    case createEventButtonTapped
    case stabbingButtonTapped
    case selectPICButtonTapped
    case selectedPhotosInfo([PhotoInfo])
    
    // Internal Action
    case kookResponse(Result<KookInfo, Error>)
    case getUploadURLResponse(Result<FileUploadInfo, Error>, PhotoInfo)
    case uploadFileToPresignedURLResponse(Result<Void, Error>)
    
    public enum Delegate {
      case headerButtonTapped(Int)
      case createEventButtonTapped(Int)
      case stabbingSuccessed
      case stabbingFailed
      case imageUploadSuccessed
      case imageUploadFailed
      case selectPICButtonTapped
    }
  }
  
  @Dependency(\.pushNotificationAPIClient) var pushNotificationAPIClient
  @Dependency(\.fileUploadAPIClient) var fileUploadAPIClient

  public var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .delegate:
        return .none
        
      case .headerButtonTapped:
        return .send(.delegate(.headerButtonTapped(state.id)))
        
      case .createEventButtonTapped:
        return .send(.delegate(.createEventButtonTapped(state.id)))
        
      case .stabbingButtonTapped:
        return .run { [state] send in
          await send(.kookResponse(Result {
            try await self.pushNotificationAPIClient.kook(
              accessToken: state.userInfo.accessToken,
              eventID: state.recentEvent.id
            )
          }))
        }
        
      case .selectPICButtonTapped:
        return .send(.delegate(.selectPICButtonTapped))
        
      case let .selectedPhotosInfo(photosInfo):
        return .run { [state] send in
          if !photosInfo.isEmpty {
            let photoInfo = photosInfo[0]
            await send(
              .getUploadURLResponse(
                Result {
                  try await self.fileUploadAPIClient.getUploadURL(
                    accessToken: state.userInfo.accessToken,
                    fileExtension: photoInfo.fileExtension
                  )
                },
                photoInfo
              )
            )
          }
        }
        
      case .kookResponse(.success):
        state.stabbingButtonType = .inactive
        return .send(.delegate(.stabbingSuccessed))
        
      case let .kookResponse(.failure(error)):
        return .run { send in
          logger.error(error.localizedDescription)
          await send(.delegate(.stabbingFailed))
        }
        
      case let .getUploadURLResponse(.success(fileUploadInfo), photoInfo):
        return .run { send in
          await send(
            .uploadFileToPresignedURLResponse(
              Result {
                try await self.fileUploadAPIClient.uploadFile(
                  uploadURL: fileUploadInfo.uploadURL,
                  data: photoInfo.data,
                  fileExtension: photoInfo.fileExtension
                )
              }
            )
          )
        }
        
      case let .getUploadURLResponse(.failure(error), _):
        return .run { send in
          logger.error(error.localizedDescription)
          await send(.delegate(.imageUploadFailed))
        }
        
      case .uploadFileToPresignedURLResponse(.success):
        return .run { send in
          await send(.delegate(.imageUploadSuccessed))
        }
        
      case let .uploadFileToPresignedURLResponse(.failure(error)):
        return .run { send in
          logger.error(error.localizedDescription)
          await send(.delegate(.imageUploadFailed))
        }
      }
    }
  }
}
