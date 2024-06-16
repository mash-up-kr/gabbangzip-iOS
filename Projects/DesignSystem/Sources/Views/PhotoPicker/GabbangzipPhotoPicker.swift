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
  @Binding private var selectedImages: [UIImage]
  @Binding private var isPresentedError: Bool
  private let maxSelectedCount: MaxSelectedCountType
  private var disabled: Bool {
    selectedImages.count >= maxSelectedCount.rawValue
  }
  private var availableSelectedCount: Int {
    maxSelectedCount.rawValue - selectedImages.count
  }
  private let matching: PHPickerFilter
  private let photoLibrary: PHPhotoLibrary
  private let content: () -> Content
  
  public init(
    selectedImages: Binding<[UIImage]>,
    isPresentedError: Binding<Bool> = .constant(false),
    maxSelectedCount: MaxSelectedCountType = .multiple,
    matching: PHPickerFilter = .images,
    photoLibrary: PHPhotoLibrary = .shared(),
    content: @escaping () -> Content
  ) {
    self._selectedImages = selectedImages
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
    for newPhoto in newPhotos {
      newPhoto.loadTransferable(type: Data.self) { result in
        switch result {
        case .success(let data):
          if let data = data, let newImage = UIImage(data: data) {
            if !selectedImages.contains(where: { $0.pngData() == newImage.pngData() }) {
              DispatchQueue.main.async {
                selectedImages.append(newImage)
              }
            }
          }
        case .failure:
          isPresentedError = true
        }
      }
    }
    
    selectedPhotos.removeAll()
  }
}
