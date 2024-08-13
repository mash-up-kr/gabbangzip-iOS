//
//  GroupDetailCore.swift
//  GroupDetail
//
//  Created by 최혜린 on 6/29/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import ComposableArchitecture
import DesignSystem
import Models
import Services
import UIKit

@Reducer
public struct GroupDetailCore {
  public init() {}
  
  @ObservableState
  public struct State: Equatable {
    var groupID: Int
    var groupDetail: GroupDetailInfo?
    var showSheet: Bool
    var selectedPhotosInfo: [PhotoInfo]
    var isToastPresented: Bool
    var toastType: ToastType
    var s3BucketDomain: String
    var showActivityView: Bool
    var capturedImage: UIImage?
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
    
    var isNeedEventCompletedTitle: Bool {
      return groupDetail?.status == .eventCompleted
    }
    
    var recentEventDateString: String {
      return groupDetail?.recentEventDetail.date.toGroupEventDateString() ?? ""
    }
    
    @Shared var userInfo: UserInfo

    public init(
      groupID: Int,
      groupDetail: GroupDetailInfo? = nil,
      showSheet: Bool = true,
      selectedPhotosInfo: [PhotoInfo] = [],
      isToastPresented: Bool = false,
      toastType: ToastType = .onlyText(""),
      s3BucketDomain: String = "",
      showActivityView: Bool = false,
      capturedImage: UIImage? = nil,
      userInfo: @autoclosure () -> UserInfo = .defaultValue
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
      self._userInfo = Shared(wrappedValue: userInfo(), .inMemory("userInfo"))
    }
  }
  
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
    case selectedPhotos([PhotoInfo])
    case historyViewTapped(History)
    case shareButtonTapped
    case imageCaptured(UIImage?)

    // Internal Action
    case getGroupDetailResponse(Result<GroupDetailInfo, Error>)
    case putEventVisit(Result<EventVisitInfo, Error>)
    case postKook(Result<KookInfo, Error>)
    case getUploadURLResponse(Result<FileUploadInfo, Error>, PhotoInfo)
    case uploadFileToPresignedURLResponse(Result<Void, Error>)
    case showToast(DetailToastType)

    // Route Action
    case backToHome
    case moveToMemberList(Int)
    case moveToVote(Int)
    case moveToHistoryDetail(History, GroupData.Keyword?, String)
  }

  public var body: some Reducer<State, Action> {
    BindingReducer()
    
    Reduce { state, action in
      switch action {
      case .binding:
        return .none
        
      // View Action
      case .onAppear:
        return .run(
          operation: { [state] send in
            await send(.getGroupDetailResponse(Result {
              try await self.groupAPIClient.getGroupDetail(state.userInfo.accessToken, state.groupID)
            }))
          }
        )
        
      case .backButtonTapped:
        return .send(.backToHome)
        
      case .memberListButtonTapped:
        return .send(.moveToMemberList(state.groupID))
        
      case let .eventContainerViewButtonTapped(status):
        switch status {
        case .beforeMyVote:
          return .send(.moveToVote(state.groupDetail?.recentEventDetail.id ?? 0))
        case .afterMyVote, .afterMyUpload:
          return .run { [state] send in
            await send(.postKook(Result {
              try await self.pushAPIClienet.kook(
                accessToken: state.userInfo.accessToken,
                eventID: state.groupDetail?.recentEventDetail.id ?? 0
              )
            }))
          }
        default:
          return .none
        }
        
      case let .selectedPhotos(photosInfo):
        return .run { [state] send in
          if let firstPhotoInfo = photosInfo[safe: 0] {
            await send(.getUploadURLResponse(
              Result {
                try await self.fileUploadAPIClient.getUploadURL(
                  state.userInfo.accessToken,
                  firstPhotoInfo.fileExtension
                )
              },
              firstPhotoInfo)
            )
          }
        }
        
      case let .historyViewTapped(history):
        return .send(GroupDetailCore.Action.moveToHistoryDetail(history, state.groupDetail?.keyword, state.s3BucketDomain))
        
      case .shareButtonTapped:
        state.showActivityView = true
        return .none
        
      case let .imageCaptured(image):
        state.capturedImage = image
        return .none
        
      // Internal Action
      case let .getGroupDetailResponse(.success(groupDetailInfo)):
        state.groupDetail = groupDetailInfo
        
        if state.groupDetail?.status == .eventCompleted {
          return .run(
            operation: { [state] send in
              await send(.putEventVisit(Result {
                try await self.eventAPIClient.putEventVisit(
                  accessToken: state.userInfo.accessToken,
                  eventID: state.groupDetail?.recentEventDetail.id ?? -1
                )
              }))
            }
          )
        } else {
          return .none
        }
        
      case .getGroupDetailResponse(.failure):
        return .none
        
      case .putEventVisit:
        return .none
        
      case .postKook:
        return .none
        
      case let .getUploadURLResponse(.success(fileUploadInfo), photoInfo):
        return .run(
          operation: { send in
            await send(.uploadFileToPresignedURLResponse(Result {
              try await self.fileUploadAPIClient.uploadFile(
                uploadURL: fileUploadInfo.uploadURL,
                data: photoInfo.data,
                fileExtension: photoInfo.fileExtension
              )
            }))
          }
        )
        
      case .getUploadURLResponse(.failure, _):
        return .send(.showToast(.imageUploadFail))
        
      case .uploadFileToPresignedURLResponse(.success):
        return .send(.showToast(.imageUploadSuccess))
        
      case .uploadFileToPresignedURLResponse(.failure):
        return .send(.showToast(.imageUploadFail))
        
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
      }
    }
  }
}

extension GroupDetailCore {
  public enum DetailToastType {
    case imageUploadSuccess
    case imageUploadFail
    
    var type: ToastType {
      switch self {
      case .imageUploadSuccess:
        return .textWithCheckIcon("이미지 업로드 성공!")
      case .imageUploadFail:
        return .textWithInfoIcon("이미지 업로드 실패!")
      }
    }
  }
}
