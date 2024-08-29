//
//  GroupDetailCore.swift
//  GroupDetail
//
//  Created by 최혜린 on 6/29/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import Common
import ComposableArchitecture
import DesignSystem
import Models
import Services
import SwiftUI
import UIKit
import _PhotosUI_SwiftUI

@Reducer
public struct GroupDetailCore {
  public init() {}
  
  @ObservableState
  public struct State: Equatable {
    var groupID: Int
    var groupDetail: GroupDetailInfo?
    var showSheet: Bool
    var selectedPhotosInfo: [PhotoInfo]
    var selectedImageURLs: [String]
    var isImageUploaded: Bool
    var isToastPresented: Bool
    var toastType: ToastType
    var s3BucketDomain: String
    var showActivityView: Bool
    var capturedImage: UIImage?
    var photosPickerPresented: Bool
    var selectedPickerItems: [PhotosPickerItem]

    var smallButtonType: SmallButtonContentType {
      if let groupDetail {
        switch groupDetail.status {
        case .noCurrentEvent, .noPastAndCurrentEvent, .eventCompleted:
          return .generateEvent
        case .beforeMyUpload:
          return .uploadPIC
        case .beforeMyVote:
          return .vote
        case .afterMyUpload, .afterMyVote:
          return .stabbing
        }
      } else {
        return .generateEvent
      }
    }

    var frame: Image {
      return groupDetail?.keyword.frame ?? DesignSystem.Icons.plusFrame
    }
    
    var recentEventDateString: String {
      return groupDetail?.recentEventDetail.date.toGroupEventDateString(type: .eventDate) ?? ""
    }
    
    var recentEventName: String {
      return groupDetail?.recentEventDetail.name ?? ""
    }
    
    var recentEventDeadLineString: String {
      return groupDetail?.recentEventDetail.deadline.toGroupEventDateString(type: .deadline) ?? ""
    }
    
    var statusMessage: String {
      return groupDetail?.status.message ?? ""
    }
    
    var cardFrontImageURLString: String {
      return s3BucketDomain + (groupDetail?.cardFrontImageURL ?? "")
    }
    
    @Shared var userInfo: UserInfo

    public init(
      groupID: Int,
      groupDetail: GroupDetailInfo? = nil,
      showSheet: Bool = true,
      selectedPhotosInfo: [PhotoInfo] = [],
      isToastPresented: Bool = false,
      toastType: ToastType = .onlyText("다시 시도해주세요."),
      s3BucketDomain: String = "",
      showActivityView: Bool = false,
      capturedImage: UIImage? = nil,
      selectedImageURLs: [String] = [],
      isImageUploaded: Bool = false,
      userInfo: @autoclosure () -> UserInfo = .defaultValue,
      photosPickerPresented: Bool = false,
      selectedPickerItems: [PhotosPickerItem] = []
    ) {
      self.groupID = groupID
      self.groupDetail = groupDetail
      self.showSheet = showSheet
      self.selectedPhotosInfo = selectedPhotosInfo
      self.isToastPresented = isToastPresented
      self.toastType = toastType
      self.s3BucketDomain = s3BucketDomain
      self.showActivityView = showActivityView
      self.capturedImage = capturedImage
      self.selectedImageURLs = selectedImageURLs
      self.isImageUploaded = isImageUploaded
      self._userInfo = Shared(wrappedValue: userInfo(), .inMemory("userInfo"))
      self.photosPickerPresented = photosPickerPresented
      self.selectedPickerItems = selectedPickerItems
    }
  }
  
  @Dependency(\.bundleClient) var bundleClient
  @Dependency(\.groupAPIClient) var groupAPIClient
  @Dependency(\.eventAPIClient) var eventAPIClient
  @Dependency(\.pushNotificationAPIClient) var pushAPIClienet
  @Dependency(\.fileUploadAPIClient) var fileUploadAPIClient

  public enum Action: BindableAction {
    case binding(BindingAction<State>)
    
    // View Action
    case onAppear
    case backButtonTapped
    case memberListButtonTapped
    case eventContainerViewButtonTapped(GroupData.Status)
    case historyViewTapped(History)
    case shareButtonTapped
    case galleryButtonTapped
    case imageCaptured(UIImage?)
    case createEventButtonTapped

    // Internal Action
    case setS3BucketDomain(String)
    case getGroupDetailResponse(Result<GroupDetailInfo, Error>)
    case putEventVisit(Result<EventVisitInfo, Error>)
    case postKook(Result<KookInfo, Error>)
    case showToast(DetailToastType)
    case photosPickerPresentedChanged(Bool)
    case selectedPickerItemsChanged([PhotosPickerItem])

    // Route Action
    case backToHome
    case moveToMemberList(Int, GroupData.Keyword)
    case moveToVote(Int)
    case moveToHistoryDetail(History, GroupData.Keyword?, String)
    case moveToCreateEvent(Int)
  }

  public var body: some Reducer<State, Action> {
    BindingReducer()
    
    Reduce { state, action in
      switch action {
      case .binding:
        return .none
        
      // View Action
      case .onAppear:
        state.showSheet = true
        return .run(
          operation: { [state] send in
            if let s3BucketDomain = try? bundleClient.getValue(key: "S3BucketDomain") as? String {
              await send(.setS3BucketDomain(s3BucketDomain))
            }
            
            await send(.getGroupDetailResponse(Result {
              try await self.groupAPIClient.getGroupDetail(state.userInfo.accessToken, state.groupID)
            }))
          }
        )
        
      case .backButtonTapped:
        return .send(.backToHome)
        
      case .memberListButtonTapped:
        state.showSheet = false
        return .send(.moveToMemberList(state.groupID, state.groupDetail?.keyword ?? .company))
        
      case let .eventContainerViewButtonTapped(status):
        switch status {
        case .beforeMyVote:
          return .send(.moveToVote(state.groupDetail?.recentEventDetail.id ?? 0))
        case .afterMyVote, .afterMyUpload:
          return .run { [state] send in
            await send(.postKook(Result {
              try await self.pushAPIClienet.kook(
                state.userInfo.accessToken,
                state.groupDetail?.recentEventDetail.id ?? 0
              )
            }))
          }
        default:
          return .none
        }
        
      case let .historyViewTapped(history):
        return .send(GroupDetailCore.Action.moveToHistoryDetail(
          history,
          state.groupDetail?.keyword,
          state.s3BucketDomain
        ))
        
      case .shareButtonTapped:
        state.showActivityView = true
        return .none
        
      case .galleryButtonTapped:
        state.photosPickerPresented = true
        return .none
        
      case let .imageCaptured(image):
        state.capturedImage = image
        return .none
        
      case .createEventButtonTapped:
        return .send(.moveToCreateEvent(state.groupID))
        
      case let .setS3BucketDomain(s3BucketDomain):
        state.s3BucketDomain = s3BucketDomain
        return .none
        
      // Internal Action
      case let .getGroupDetailResponse(.success(groupDetailInfo)):
        state.groupDetail = groupDetailInfo
        
        if state.groupDetail?.status == .eventCompleted {
          return .run(
            operation: { [state] send in
              await send(.putEventVisit(Result {
                try await self.eventAPIClient.putEventVisit(
                  state.userInfo.accessToken,
                  state.groupDetail?.recentEventDetail.id ?? -1
                )
              }))
            }
          )
        } else {
          return .none
        }
        
      case .getGroupDetailResponse(.failure):
        state.isToastPresented = true
        return .none
        
      case .putEventVisit(.success):
        return .none
        
      case .putEventVisit(.failure):
        state.isToastPresented = true
        return .none
        
      case .postKook(.success):
        return .send(.showToast(.kookSuccess))
        
      case .postKook(.failure):
        return .send(.showToast(.kookFail))
        
      case let .showToast(detailToastType):
        state.isToastPresented = true
        state.toastType = detailToastType.type
        return .none

      // Route Action
      case .backToHome:
        return .none
        
      case .moveToMemberList:
        return .none
        
      case .moveToVote:
        return .none
        
      case .moveToHistoryDetail:
        return .none
        
      case let .photosPickerPresentedChanged(value):
        state.photosPickerPresented = value
        return .none
        
      case let .selectedPickerItemsChanged(value):
        state.selectedPickerItems = value
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
                eventID: state.groupDetail?.recentEventDetail.id ?? 0,
                imageURLs: selectedImageURLs
              )
              
              await send(.showToast(.imageUploadSuccess))
            }
          },
          catch: { error, send in
            logger.error(error.localizedDescription)
            await send(.showToast(.imageUploadFail))
          }
        )
        
      case .moveToCreateEvent:
        return .none
      }
    }
  }
}

extension GroupDetailCore {
  public enum DetailToastType {
    case imageUploadSuccess
    case imageUploadFail
    case kookSuccess
    case kookFail
    
    var type: ToastType {
      switch self {
      case .imageUploadSuccess:
        return .textWithCheckIcon("내 PIC 올리기 완료!")
      case .imageUploadFail, .kookFail:
        return .textWithInfoIcon("잠시 후 다시 시도해 주세요")
      case .kookSuccess:
        return .onlyText("그룹원들을 쿡 찔렀어요!")
      }
    }
  }
}
