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
      
      Text(store.nickname)
        .font(.head20)
        .foregroundColor(DesignSystem.Colors.gray80)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.all, 16)
      
      Spacer()
        .frame(height: 16)
      
      Color(DesignSystem.Colors.gray20)
        .frame(height: 16)
      
      Spacer()
        .frame(height: 16)
      
      Text(store.alarmSetting)
        .font(.head14)
        .foregroundColor(DesignSystem.Colors.gray80)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 20)
        .padding(.horizontal, 16)
      
      HStack {
        Text(store.appAlarm)
          .font(.body16)
          .foregroundColor(DesignSystem.Colors.gray80)
          .frame(maxWidth: .infinity, alignment: .leading)
          .padding(.vertical, 20)
          .padding(.horizontal, 16)
        
        Text(store.alarmStatus)
          .font(.body16)
          .foregroundColor(DesignSystem.Colors.gray60)
          .frame(maxWidth: .infinity, alignment: .trailing)
          .padding(.vertical, 20)
          .padding(.horizontal, 16)
      }
      
      Spacer()
        .frame(height: 10)
      
      Color(DesignSystem.Colors.gray20)
        .frame(height: 2)
      
      Spacer()
        .frame(height: 10)
      
      Text(store.userSetting)
        .font(.head14)
        .foregroundColor(DesignSystem.Colors.gray80)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 20)
        .padding(.horizontal, 16)
      
      HStack {
        Text(store.version)
          .font(.body16)
          .foregroundColor(DesignSystem.Colors.gray80)
          .frame(maxWidth: .infinity, alignment: .leading)
          .padding(.vertical, 20)
          .padding(.horizontal, 16)
        
        Text(store.currentVersion)
          .font(.body16)
          .foregroundColor(DesignSystem.Colors.gray60)
          .frame(maxWidth: .infinity, alignment: .trailing)
          .padding(.vertical, 20)
          .padding(.horizontal, 16)
      }
      
      Text(store.logout)
        .font(.body16)
        .foregroundColor(DesignSystem.Colors.gray80)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 20)
        .padding(.horizontal, 16)
      
      Text(store.unregister)
        .font(.body16)
        .foregroundColor(DesignSystem.Colors.gray80)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 20)
        .padding(.horizontal, 16)
      
      Spacer()
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
