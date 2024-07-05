//
//  MyPageView.swift
//  MyPage
//
//  Created by Hyun A Song on 7/5/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import ComposableArchitecture
import DesignSystem
import SwiftUI

public struct MyPageView: View {
  let store: StoreOf<MyPageCore>
  
  public init(store: StoreOf<MyPageCore>) {
    self.store = store
  }
  
  public var body: some View {
    VStack {
      NavigationBar(type: .titleWithBackButton(store.myPageTitle))
      
      SettingTextView(
        text: store.nickname,
        font: .head20,
        verticalPadding: 16
      )
      
      SeparatorView(height: 16, padding: 16)
      
      SettingTextView(
        text: store.alarmSetting,
        font: .head14
      )
      
      Button(action: {
        
      }, label: {
        HStack {
          SettingTextView(text: store.appAlarm)
          
          SettingTextView(
            text: store.alarmStatus,
            color: DesignSystem.Colors.gray60,
            alignment: .trailing
          )
        }
      })
      
      SeparatorView(height: 2, padding: 10)
      
      SettingTextView(
        text: store.userSetting,
        font: .head14
      )
      
      HStack {
        SettingTextView(text: store.version)
        
        SettingTextView(
          text: store.currentVersion,
          color: DesignSystem.Colors.gray60,
          alignment: .trailing
        )
      }
      
      Button(action: {
        
      }, label: {
        SettingTextView(text: store.logout)
      })
      
      Button(action: {
        
      }, label: {
        SettingTextView(text: store.unregister)
      })
      
      Spacer()
    }
  }
}

// MARK: - CustomView
extension MyPageView {
  private struct SettingTextView: View {
    var text: String
    var font: Font
    var color: Color
    var alignment: Alignment
    var verticalPadding: CGFloat
    var horizontalPadding: CGFloat
    
    init(text: String,
         font: Font = .body16,
         color: Color = DesignSystem.Colors.gray80,
         alignment: Alignment = .leading,
         verticalPadding: CGFloat = 20,
         horizontalPadding: CGFloat = 16
    ) {
      self.text = text
      self.font = font
      self.color = color
      self.alignment = alignment
      self.verticalPadding = verticalPadding
      self.horizontalPadding = horizontalPadding
    }
    
    var body: some View {
      Text(text)
        .font(font)
        .foregroundColor(color)
        .frame(maxWidth: .infinity, alignment: alignment)
        .padding(.vertical, verticalPadding)
        .padding(.horizontal, horizontalPadding)
    }
  }
  
  private struct SeparatorView: View {
    var height: CGFloat
    var padding: CGFloat
    
    init(height: CGFloat, padding: CGFloat) {
      self.height = height
      self.padding = padding
    }
    
    var body: some View {
      Color(DesignSystem.Colors.gray20)
        .frame(height: height)
        .padding(.vertical, padding)
    }
  }
}

#Preview {
  MyPageView(
    store: Store(
      initialState: MyPageCore.State(alarmStatus: "on", nickname: "가빵집"),
      reducer: MyPageCore.init
    )
  )
}
