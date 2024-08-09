//
//  GabbangzipDate.swift
//  DesignSystem
//
//  Created by Hyun A Song on 8/9/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import SwiftUI

public struct GabbangzipDate: View {
  private var date: String
  
  public init(
    date: String
  ) {
    self.date = date
  }
  
  public var body: some View {
    HStack(spacing: 0) {
      Image(uiImage: DesignSystem.Icons.calendarUIImage)
        .resizable()
        .frame(width: 20, height: 20)
        .padding(.leading, 16)
        .padding(.trailing, 10)
      
      Text(date)
        .font(.body16)
        .foregroundStyle(DesignSystem.Colors.gray60)
        .padding(.vertical, 18)
      
      Spacer()
    }
    .background(DesignSystem.Colors.gray40)
    .cornerRadius(10)
  }
}

#Preview {
  VStack {
    GabbangzipDate(date: "YY/MM/DD")
  }
}
