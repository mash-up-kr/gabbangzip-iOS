//
//  SelectGroupPhotoCore.swift
//  CreateGroup
//
//  Created by YangJoonHyeok on 7/9/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import Common
import ComposableArchitecture
import DesignSystem
import Models
import Services

@Reducer
public struct SelectGroupPhotoCore {
  public init() {}
  
  @ObservableState
  public struct State: Equatable {
    @Shared var userInfo: UserInfo
    @Shared var isHomeUpdated: Bool
    var groupName: String
    var keyword: GroupData.Keyword
    var nextButtonType: ButtonType
    var selectedPhotosInfo: [PhotoInfo]
    var isFromGetStarted: Bool

    public init(
      userInfo: @autoclosure () -> UserInfo = .defaultValue,
      isHomeUpdated: @autoclosure () -> Bool = false,
      groupName: String,
      keyword: GroupData.Keyword,
      nextButtonType: ButtonType = .inactive,
      selectedPhotosInfo: [PhotoInfo] = [],
      isFromGetStarted: Bool
    ) {
      self._userInfo = Shared(wrappedValue: userInfo(), .inMemory("userInfo"))
      self._isHomeUpdated = Shared(wrappedValue: isHomeUpdated(), .inMemory("isHomeUpdated"))
      self.groupName = groupName
      self.nextButtonType = nextButtonType
      self.keyword = keyword
      self.selectedPhotosInfo = selectedPhotosInfo
      self.isFromGetStarted = isFromGetStarted
    }
  }

  public enum Action {
    // View Action
    case nextButtonTapped
    case selectedImagesChanged([PhotoInfo])
    case backButtonTapped
    
    // Internal Action
    case getUploadURLResponse(Result<FileUploadInfo, Error>, PhotoInfo)
    case uploadFileToPresignedURLResponse(Result<Void, Error>, FileUploadInfo)
    case createGroupResponse(Result<CreatedGroupInfo, Error>)
    
    // Route Action
    case moveToCreateGroupCompletion(createdGroupInfo: CreatedGroupInfo, isFromGetStarted: Bool)
    case backToSelectKeyword
  }
  
  @Dependency(\.fileUploadAPIClient) var fileUploadAPIClient
  @Dependency(\.createGroupAPIClient) var createGroupAPIClient

  public var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .nextButtonTapped:
        return .run { [state] send in
          if !state.selectedPhotosInfo.isEmpty {
            let photoInfo = state.selectedPhotosInfo[0]
            await send(
              .getUploadURLResponse(
                Result {
                  try await self.fileUploadAPIClient.getUploadURL(
                    state.userInfo.accessToken,
                    photoInfo.fileExtension)
                }, photoInfo
              )
            )
          }
        }
        
      case let .selectedImagesChanged(imagesData):
        state.selectedPhotosInfo = imagesData
        if !imagesData.isEmpty {
          state.nextButtonType = .active
        }
        return .none
        
      case .backButtonTapped:
        return .send(.backToSelectKeyword)
        
      case let .getUploadURLResponse(.success(fileUploadInfo), photoInfo):
        return .run { send in
          await send(
            .uploadFileToPresignedURLResponse(
              Result {
                try await self.fileUploadAPIClient.uploadFile(
                  fileUploadInfo.uploadURL,
                  photoInfo.data,
                  photoInfo.fileExtension)
              },
              fileUploadInfo
            )
          )
        }
        
      case let .getUploadURLResponse(.failure(error), _):
        return .run { send in
          logger.error(error.localizedDescription)
        }
        
      case let .uploadFileToPresignedURLResponse(.success, fileUploadInfo):
        return .run { [state] send in
          await send(.createGroupResponse(Result {
            try await self.createGroupAPIClient.createGroup(
              state.userInfo.accessToken,
              state.groupName,
              state.keyword.rawValue,
              fileUploadInfo.fileID
            )
          }))
        }
        
      case let .uploadFileToPresignedURLResponse(.failure(error), _):
        return .run { send in
          logger.error(error.localizedDescription)
        }
        
      case let .createGroupResponse(.success(createdGroupInfo)):
        state.isHomeUpdated = true
        return .send(.moveToCreateGroupCompletion(createdGroupInfo: createdGroupInfo, isFromGetStarted: state.isFromGetStarted))
        
      case let .createGroupResponse(.failure(error)):
        return .run { send in
          logger.error(error.localizedDescription)
        }

      case .moveToCreateGroupCompletion:
        return .none
        
      case .backToSelectKeyword:
        return .none
      }
    }
  }
}
