//
//  GabbangzipPhotoPicker.swift
//  DesignSystem
//
//  Created by GREEN on 6/12/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import PhotosUI
import SwiftUI

public struct GabbangzipPhotoPicker<Content: View>: View {
  @State private var selectedPhotos: [PhotosPickerItem] = []
  @Binding private var selectedPhotosInfo: [PhotoInfo]
  @Binding private var isPresentedError: Bool
  private let maxSelectedCount: MaxSelectedCountType
  private var disabled: Bool {
    if case .single = maxSelectedCount {
      return false
    } else {
      return selectedPhotosInfo.count >= maxSelectedCount.rawValue
    }
  }
  private var availableSelectedCount: Int {
    if case .single = maxSelectedCount {
      return 1
    } else {
      return maxSelectedCount.rawValue - selectedPhotosInfo.count
    }
  }
  private let matching: PHPickerFilter
  private let photoLibrary: PHPhotoLibrary
  private let content: () -> Content
  
  public init(
    selectedPhotosInfo: Binding<[PhotoInfo]>,
    isPresentedError: Binding<Bool> = .constant(false),
    maxSelectedCount: MaxSelectedCountType = .four,
    matching: PHPickerFilter = .images,
    photoLibrary: PHPhotoLibrary = .shared(),
    content: @escaping () -> Content
  ) {
    self._selectedPhotosInfo = selectedPhotosInfo
    self._isPresentedError = isPresentedError
    self.maxSelectedCount = maxSelectedCount
    self.matching = matching
    self.photoLibrary = photoLibrary
    self.content = content
  }
  
  public var body: some View {
    PhotosPicker(
      selection: $selectedPhotos,
      maxSelectionCount: availableSelectedCount,
      matching: matching,
      photoLibrary: photoLibrary
    ) {
      content()
        .disabled(disabled)
    }
    .disabled(disabled)
    .onChange(of: selectedPhotos) { _, newValue in
      handleSelectedPhotos(newValue)
    }
  }
  
  private func handleSelectedPhotos(_ newPhotos: [PhotosPickerItem]) {
    Task {
      for newPhoto in newPhotos {
        await processPhoto(newPhoto)
      }
      selectedPhotos.removeAll()
    }
  }
  
  private func processPhoto(_ photo: PhotosPickerItem) async {
    do {
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
      
      await MainActor.run {
        if case .single = maxSelectedCount {
          selectedPhotosInfo.removeAll()
          selectedPhotosInfo.append(photoInfo)
        } else {
          if !selectedPhotosInfo.contains(where: { $0 == photoInfo }) {
            selectedPhotosInfo.append(photoInfo)
          }
        }
      }
    } catch {
      await MainActor.run {
        isPresentedError = true
      }
    }
  }
}
