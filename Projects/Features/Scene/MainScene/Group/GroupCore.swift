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
import _PhotosUI_SwiftUI

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
    var selectedImageURLs: [String]
    var stabbingButtonType: SmallButtonType
    var photosPickerPresented: Bool
    var selectedPickerItems: [PhotosPickerItem]
    var hasNoEvent: Bool {
      return status == .noPastAndCurrentEvent
    }
    var hasCompletedEvent: Bool {
      return status == .noCurrentEvent || status == .eventCompleted
    }
    var recentEventDate: String {
      return recentEvent.date?.toGroupEventDateString(type: .eventDate) ?? ""
    }
    var recentEventName: String {
      return recentEvent.name ?? ""
    }
    var frontTitle: String {
      return status == .noPastAndCurrentEvent ? "이벤트를 만들어 보세요!" : recentEventDate
    }
    var isAllPhotoAdded: Bool {
      return selectedPhotosInfo.count == 4
    }
    var isAllPhotoUploaded: Bool {
      return selectedImageURLs.count == 4
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
      selectedImageURLs: [String] = [],
      stabbingButtonType: SmallButtonType = .active,
      photosPickerPresented: Bool = false,
      selectedPickerItems: [PhotosPickerItem] = []
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
      self.selectedImageURLs = selectedImageURLs
      self.stabbingButtonType = stabbingButtonType
      self.photosPickerPresented = photosPickerPresented
      self.selectedPickerItems = selectedPickerItems
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
    case galleryButtonTapped
    case photosPickerPresentedChanged(Bool)
    case selectedPickerItemsChanged([PhotosPickerItem])
    
    // Internal Action
    case kookResponse(Result<KookInfo, Error>)
    
    public enum Delegate {
      case headerButtonTapped(Int)
      case createEventButtonTapped(Int)
      case stabbingSuccessed
      case stabbingFailed
      case imageUploadSuccessed
      case imageUploadFailed
      case selectPICButtonTapped(Int)
    }
  }
  
  @Dependency(\.pushNotificationAPIClient) var pushNotificationAPIClient
  @Dependency(\.fileUploadAPIClient) var fileUploadAPIClient
  @Dependency(\.eventAPIClient) var eventAPIClient

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
        return .send(.delegate(.selectPICButtonTapped(state.recentEvent.id)))
        
      case .galleryButtonTapped:
        state.photosPickerPresented = true
        return .none
        
      case let .photosPickerPresentedChanged(value):
        state.photosPickerPresented = value
        return .none
        
      case let .selectedPickerItemsChanged(value):
        return .run(
          operation: { [state] send in
            if !value.isEmpty {
              var selectedPhotosInfo: [PhotoInfo] = []
              var selectedImageURLs: [String] = []
              
              try await withThrowingTaskGroup(of: PhotoInfo.self) { group in
                for photo in value {
                  group.addTask {
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
                    
                    return PhotoInfo(data: imageData, url: dataUrl.url)
                  }
                }
                
                for try await selectedPhotoInfo in group {
                  selectedPhotosInfo.append(selectedPhotoInfo)
                }
              }
              
              try await withThrowingTaskGroup(of: String.self) { group in
                for selectedPhoto in selectedPhotosInfo {
                  group.addTask {
                    let fileUploadInfo = try await self.fileUploadAPIClient.getUploadURL(
                      accessToken: state.userInfo.accessToken,
                      fileExtension: selectedPhoto.fileExtension
                    )
                    
                    try await self.fileUploadAPIClient.uploadFile(
                      uploadURL: fileUploadInfo.uploadURL,
                      data: selectedPhoto.data,
                      fileExtension: selectedPhoto.fileExtension
                    )
                    
                    return fileUploadInfo.fileID
                  }
                }
                
                for try await fileID in group {
                  selectedImageURLs.append(fileID)
                }
              }
              
              _ = try await self.eventAPIClient.postImages(
                accessToken: state.userInfo.accessToken,
                eventID: state.recentEvent.id,
                imageURLs: selectedImageURLs
              )
              
              await send(.delegate(.imageUploadSuccessed))
            }
          },
          catch: { error, send in
            logger.error(error.localizedDescription)
            await send(.delegate(.imageUploadFailed))
          }
        )
        
      case .kookResponse(.success):
        state.stabbingButtonType = .inactive
        return .send(.delegate(.stabbingSuccessed))
        
      case let .kookResponse(.failure(error)):
        return .run { send in
          logger.error(error.localizedDescription)
          await send(.delegate(.stabbingFailed))
        }
      }
    }
  }
}
