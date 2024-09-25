//
//  CreateEventCore.swift
//  CreateEvent
//
//  Created by Hyun A Song on 8/8/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import Common
import ComposableArchitecture
import DesignSystem
import Foundation
import Models
import Services

@Reducer
public struct CreateEventCore {
  public init() {}
  
  @ObservableState
  public struct State: Equatable {
    @Shared var userInfo: UserInfo
    public var groupID: Int
    public var text: String
    public var isExiting: Bool
    public var isErrorPresented: Bool
    public var isEventNamed: Bool
    public var isPhotoSelected: Bool
    public var isTouchedOnce: Bool
    public var completeButtonType: ButtonType
    public var selectedPhotosInfo: [PhotoInfo]
    public var imageURL: [String]
    public var isLoading: Bool
    public var isDatePickerVisible: Bool
    public var selectedDate: Date
    public var recentEventDate: String {
      return DateFormatter.createEvent.string(from: selectedDate)
    }
    public var uploadEventDate: String {
      return DateFormatter.iso8601.string(from: selectedDate)
    }
    
    public init(
      userInfo: @autoclosure () -> UserInfo = .defaultValue,
      groupID: Int = -1,
      text: String = "",
      isExiting: Bool = false,
      isErrorPresented: Bool = false,
      isEventNamed: Bool = false,
      isPhotoSelected: Bool = false,
      isTouchedOnce: Bool = false,
      completeButtonType: ButtonType = .inactive,
      selectedPhotosInfo: [PhotoInfo] = [],
      imageURL: [String] = [],
      isLoading: Bool = false,
      isDatePickerVisible: Bool = false,
      selectedDate: Date = Date()
    ) {
      self._userInfo = Shared(wrappedValue: userInfo(), .inMemory("userInfo"))
      self.groupID = groupID
      self.text = text
      self.isExiting = isExiting
      self.isErrorPresented = isErrorPresented
      self.isEventNamed = isEventNamed
      self.isPhotoSelected = isPhotoSelected
      self.isTouchedOnce = isTouchedOnce
      self.completeButtonType = completeButtonType
      self.selectedPhotosInfo = selectedPhotosInfo
      self.imageURL = imageURL
      self.isLoading = isLoading
      self.isDatePickerVisible = isDatePickerVisible
      self.selectedDate = selectedDate
    }
  }
  
  public enum Action: BindableAction {
    case binding(BindingAction<State>)
    
    // View Action
    case textChanged(String)
    case selectedImagesChanged([PhotoInfo])
    case backButtonTapped
    case selectNewDate(Date)
    case popupLeftButtonTapped
    case popupRightButtonTapped
    case completeButtonTapped
    case deleteSelectedPhoto(Int)
    
    // Internal Action
    case changeIsEventNamedStatus(Bool)
    case changeIsPhotoSelected
    case changeIsTouchedOnce(Bool)
    case checkCompleteButtonType
    case changeIsDatePickerVisible
    case updateSelectDate(Date)
    case setToastPresented(Bool)
    case createEvent(Result<EventInfo, Error>)
    case logError(Error)
    case setIsLoading(Bool)
    
    // Route Action
    case moveToHome
    case moveToHomeWithEvent
  }
  
  @Dependency(\.bundleClient) var bundleClient
  @Dependency(\.eventAPIClient) var eventAPIClient
  @Dependency(\.fileUploadAPIClient) var fileUploadAPIClient
  @Dependency(\.uiPasteBoardClient) var uiPasteBoardClient
  
  public var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .binding:
        return .none
        
      case let .textChanged(text):
        state.text = text
        
        return .run { [state] send in
          await send(.changeIsEventNamedStatus(!state.text.isEmpty))
        }
        
      case let .selectedImagesChanged(imagesData):
        state.selectedPhotosInfo = imagesData
        return .run { send in
          await send(.changeIsPhotoSelected)
        }
        
      case .backButtonTapped:
        state.isExiting = true
        return .none
        
      case let .selectNewDate(date):
        return .run { send in
          await send(.changeIsDatePickerVisible)
          await send(.updateSelectDate(date))
        }
        
      case .popupLeftButtonTapped:
        return .run { send in
          await send(.moveToHome)
        }
        
      case .popupRightButtonTapped:
        state.isExiting = false
        return .none
        
      case .completeButtonTapped:
        state.isLoading = true
        return .run { [state] send in
          guard state.isPhotoSelected else {
            await send(.setToastPresented(true))
            await send(.setIsLoading(false))
            return
          }
          
          var selectedImageURLs: [String] = []
          
          try await withThrowingTaskGroup(of: String.self) { group in
            for selectedPhoto in state.selectedPhotosInfo {
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
          
          await send(
            .createEvent(
              Result {
                try await eventAPIClient.createEvent(
                  accessToken: state.userInfo.accessToken,
                  groupID: state.groupID,
                  description: state.text,
                  date: state.uploadEventDate,
                  pictures: selectedImageURLs
                )
              }
            )
          )
        } catch: { error, send in
          await send(.setIsLoading(false))
          await send(.logError(CreateEventCoreError(code: .failToUploadURL, underlying: error)))
        }
        
      case let .deleteSelectedPhoto(index):
        state.selectedPhotosInfo.remove(at: index)
        return .run { send in
          await send(.changeIsPhotoSelected)
        }
        
      case let .changeIsEventNamedStatus(status):
        state.isEventNamed = status
        return .run { send in
          await send(.checkCompleteButtonType)
        }
        
      case .changeIsPhotoSelected:
        state.isPhotoSelected = state.selectedPhotosInfo.count == 4 ? true : false
        return .run { send in
          await send(.checkCompleteButtonType)
        }
        
      case let .changeIsTouchedOnce(status):
        state.isTouchedOnce = status
        return .run { send in
          await send(.checkCompleteButtonType)
        }
        
      case .checkCompleteButtonType:
        state.completeButtonType = state.isEventNamed && state.isPhotoSelected && !state.isTouchedOnce
        ? .active
        : .inactive
        return .none
        
      case .changeIsDatePickerVisible:
        state.isDatePickerVisible.toggle()
        return .none
        
      case let .updateSelectDate(date):
        state.selectedDate = date
        return .none
        
      case let .setToastPresented(isPresented):
        state.isErrorPresented = isPresented
        return .none
        
      case let .createEvent(.success(eventInfo)):
        state.isLoading = false
        return .run { send in
          await send(.moveToHomeWithEvent)
        }
        
      case .createEvent(.failure):
        return .run { send in
          await send(.setIsLoading(false))
          await send(.logError(CreateEventCoreError(code: .failToCheckEvent)))
        }
        
      case let .logError(error):
        return .run { send in
          await send(.setIsLoading(true))
          logger.error("CreateEvent Error: \(error)")
        }
        
      case let .setIsLoading(value):
        state.isLoading = value
        return .none
        
      case .moveToHome:
        return .none
        
      case .moveToHomeWithEvent:
        return .none
      }
    }
  }
}

// MARK: - CreateEventCoreError
public struct CreateEventCoreError: GabbangzipError {
  public var userInfo: [String: Any] = [:]
  public var code: Code
  public var underlying: Error?
  
  public enum Code: Int {
    case failToUploadURL
    case failToUploadEventImage
    case failToCheckEvent
  }
}
