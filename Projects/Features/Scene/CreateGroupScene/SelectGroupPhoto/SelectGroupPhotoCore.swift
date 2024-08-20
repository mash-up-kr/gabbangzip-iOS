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
import _PhotosUI_SwiftUI

@Reducer
public struct SelectGroupPhotoCore {
  public init() {}
  
  @ObservableState
  public struct State: Equatable {
    @Shared var userInfo: UserInfo
    @Shared var isHomeUpdated: Bool
    var groupName: String
    var keyword: GroupData.Keyword
    var selectedPhotoInfo: PhotoInfo?
    var isFromGetStarted: Bool
    var photosPickerPresented: Bool
    var selectedPickerItems: [PhotosPickerItem]
    var nextButtonType: ButtonType {
      selectedPhotoInfo != nil ? .active : .inactive
    }

    public init(
      userInfo: @autoclosure () -> UserInfo = .defaultValue,
      isHomeUpdated: @autoclosure () -> Bool = false,
      groupName: String,
      keyword: GroupData.Keyword,
      selectedPhotoInfo: PhotoInfo? = nil,
      isFromGetStarted: Bool,
      photosPickerPresented: Bool = false,
      selectedPickerItems: [PhotosPickerItem] = []
    ) {
      self._userInfo = Shared(wrappedValue: userInfo(), .inMemory("userInfo"))
      self._isHomeUpdated = Shared(wrappedValue: isHomeUpdated(), .inMemory("isHomeUpdated"))
      self.groupName = groupName
      self.keyword = keyword
      self.selectedPhotoInfo = selectedPhotoInfo
      self.isFromGetStarted = isFromGetStarted
      self.photosPickerPresented = photosPickerPresented
      self.selectedPickerItems = selectedPickerItems
    }
  }

  public enum Action {
    // View Action
    case nextButtonTapped
    case backButtonTapped
    case frameCardButtonTapped
    case photosPickerPresentedChanged(Bool)
    case selectedPickerItemsChanged([PhotosPickerItem])
    
    // Internal Action
    case getUploadURLResponse(Result<FileUploadInfo, Error>, PhotoInfo)
    case uploadFileToPresignedURLResponse(Result<Void, Error>, FileUploadInfo)
    case createGroupResponse(Result<CreatedGroupInfo, Error>)
    case setSelectedPhotoInfo(PhotoInfo)
    
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
          if let photoInfo = state.selectedPhotoInfo {
            await send(
              .getUploadURLResponse(
                Result {
                  try await self.fileUploadAPIClient.getUploadURL(
                    state.userInfo.accessToken,
                    photoInfo.fileExtension
                  )
                }, photoInfo
              )
            )
          }
        }
        
      case .backButtonTapped:
        return .send(.backToSelectKeyword)
        
      case .frameCardButtonTapped:
        state.photosPickerPresented = true
        return .none
        
      case let .photosPickerPresentedChanged(value):
        state.photosPickerPresented = value
        return .none
        
      case let .selectedPickerItemsChanged(value):
        state.selectedPickerItems = value
        return .run(
          operation: { send in
            if let photo = value[safe: 0] {
              async let dataResult = photo.loadTransferable(type: Data.self)
              async let urlResult = photo.loadTransferable(type: DataURL.self)
              
              let (data, dataUrl) = try await (dataResult, urlResult)
              
              guard let imageData = data, let dataUrl = dataUrl else {
                throw NSError(
                  domain: "PhotoPickerError",
                  code: 0,
                  userInfo: [NSLocalizedDescriptionKey: "Failed to load image data or URL"]
                )
              }
              
              let photoInfo = PhotoInfo(data: imageData, url: dataUrl.url)
              await send(.setSelectedPhotoInfo(photoInfo))
            }
          },
          catch: { error, send in
            logger.error(error.localizedDescription)
          }
        )
        
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
        
      case let .setSelectedPhotoInfo(photoInfo):
        state.selectedPhotoInfo = photoInfo
        return .none

      case .moveToCreateGroupCompletion:
        return .none
        
      case .backToSelectKeyword:
        return .none
      }
    }
  }
}
