//
//  SelectPhoto.swift
//  DesignSystem
//
//  Created by Hyun A Song on 8/9/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import SwiftUI

public struct SelectPhoto: View {
  @Binding private var selectedPhotosInfo: [PhotoInfo]
  private let maxCount: Int
//  private let buttonTapped:
  
  public init(
    selectedPhotosInfo: Binding<[PhotoInfo]>,
    maxCount: Int
  ) {
    self._selectedPhotosInfo = selectedPhotosInfo
    self.maxCount = maxCount
  }
  
  public var body: some View {
    HStack(spacing: 0) {
      VStack(spacing: 0) {
        DesignSystem.Icons.picture
          .resizable()
          .frame(width: 28, height: 28)
          .padding(.bottom, 4)
        
        HStack(spacing: 0) {
          Text("\(selectedPhotosInfo.count)")
            .font(.body16)
            .foregroundStyle(selectedPhotosInfo.isEmpty ? DesignSystem.Colors.gray60 : DesignSystem.Colors.gray80)
          Text("/\(maxCount)")
            .font(.body16)
            .foregroundStyle(DesignSystem.Colors.gray60)
        }
      }
      .frame(width: 100, height: 100)
      .background(DesignSystem.Colors.gray40)
      .cornerRadius(10)
      .overlay{
        RoundedRectangle(cornerRadius: 10)
          .stroke(DesignSystem.Colors.gray50, lineWidth: 1)
      }
      .padding(.leading, 16)
      
      if !selectedPhotosInfo.isEmpty {
        ScrollView(.horizontal) {
          HStack {
            ForEach(Array(selectedPhotosInfo.enumerated()), id: \.offset) { index, photoInfo in
              if let image = UIImage(data: photoInfo.data) {
                ZStack(
                  alignment: .topTrailing,
                  content: {
                    Image(uiImage: image)
                      .resizable()
                      .scaledToFill()
                      .frame(width: 100, height: 100)
                      .cornerRadius(10)
                      .clipped()
                      .padding(.top, 8)
                    
                    Button(
                      action: { deletePhoto(at: index) },
                      label: {
                        DesignSystem.Icons.delete
                          .resizable()
                          .frame(width: 26, height: 26)
                      }
                    )
                    .padding([.trailing], -8)
                  }
                )
              }
            }
          }
        }
        .padding(.leading, 8)
      } else {
        Spacer()
      }
    }
  }
  
  private func deletePhoto(at index: Int) {
    guard index >= 0 && index < selectedPhotosInfo.count else { return }
    selectedPhotosInfo.remove(at: index)
  }
}

#Preview {
  VStack {
    SelectPhoto(selectedPhotosInfo: .constant([]), maxCount: 4)
  }
}
