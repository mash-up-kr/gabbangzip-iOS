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
      .padding(.top, 8)
    }
  }
}

#Preview {
  VStack {
    SelectPhoto(selectedPhotosInfo: .constant([]), maxCount: 4)
  }
}
