//
//  MyPageView.swift
//  MyPage
//
//  Created by Hyun A Song on 7/5/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import ComposableArchitecture
import DesignSystem
import Login
import SwiftUI

public struct MyPageView: View {
  @Bindable public var store: StoreOf<MyPageCore>
  @Environment(\.scenePhase) private var scenePhase
  
  public init(store: StoreOf<MyPageCore>) {
    self.store = store
  }  
  
  public var body: some View {
    VStack {
      NavigationBar(type: .titleWithBackButton(MyPageNameSpace.myPageTitle, .center))
      
      SettingTitleView(
        text: store.nickname,
        font: .head20,
        verticalPadding: 16
      )
      
      SeparatorView(height: 16, padding: 16)
      
      SettingTitleView(
        text: MyPageNameSpace.alarmSetting,
        font: .head14
      )
      
      Button(
        action: {
          store.send(.openSetting)
        }, label: {
          HStack {
            SettingTitleView(text: MyPageNameSpace.appAlarm)
            
            SettingTitleView(
              text: store.alarmStatus.rawValue,
              color: DesignSystem.Colors.gray60,
              alignment: .trailing
            )
          }
        }
      )
      
      SeparatorView(height: 2, padding: 10)
      
      SettingTitleView(
        text: MyPageNameSpace.userSetting,
        font: .head14
      )
      
      HStack {
        SettingTitleView(text: MyPageNameSpace.version)
        
        SettingTitleView(
          text: store.currentVersion,
          color: DesignSystem.Colors.gray60,
          alignment: .trailing
        )
      }
      
      Button(
        action: {
          store.send(.showPopup(true, .logout))
        }, label: {
          SettingTitleView(text: MyPageNameSpace.logout)
        }
      )
      
      
      Button(
        action: {
          store.send(.showPopup(true, .withdraw))
        }, label: {
          SettingTitleView(text: MyPageNameSpace.withdraw)
        }
      )
      
      Spacer()
    }
    .onChange(of: scenePhase) { _, newScenePhase in
      if newScenePhase == .active {
        store.send(.checkPushOn)
      }
    }
    .toast(
      isPresented: $store.isErrorPresented,
      type: .textWithInfoIcon(store.errorMessage)
    )
    .popup(
      isPresented: $store.isPopupPresented,
      title: store.popupTitle,
      description: store.popupDescription,
      leftButtonTitle: store.popupLeftButtonTitle,
      leftButtonAction: {
        store.send(.showPopup(false, store.popupType))
      },
      rightButtonTitle: store.popupRightButtonTitle,
      rightButtonAction: {
        store.send(store.popupType == .logout ? .logout : .withdraw)
        store.send(.showPopup(false, store.popupType))
      }
    )
  }
}

// MARK: - 설정 항목 타이틀 뷰
fileprivate struct SettingTitleView: View {
  private var text: String
  private var font: Font
  private var color: Color
  private var alignment: Alignment
  private var verticalPadding: CGFloat
  private var horizontalPadding: CGFloat
  
  fileprivate init(
    text: String,
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
  
  fileprivate var body: some View {
    Text(text)
      .font(font)
      .foregroundColor(color)
      .frame(maxWidth: .infinity, alignment: alignment)
      .padding(.vertical, verticalPadding)
      .padding(.horizontal, horizontalPadding)
  }
}

// MARK: - 설정 항목 구분선 뷰
fileprivate struct SeparatorView: View {
  private var height: CGFloat
  private var padding: CGFloat
  
  fileprivate init(height: CGFloat, padding: CGFloat) {
    self.height = height
    self.padding = padding
  }
  
  fileprivate var body: some View {
    Color(DesignSystem.Colors.gray20)
      .frame(height: height)
      .padding(.vertical, padding)
  }
}

// MARK: - MyPageNameSpace
extension MyPageView {
  private enum MyPageNameSpace {
    static let myPageTitle = "마이페이지"
    static let alarmSetting = "알림 설정"
    static let appAlarm = "앱 알람 설정"
    static let userSetting = "계정 설정"
    static let version = "현재 버전"
    static let logout = "로그아웃"
    static let withdraw = "회원탈퇴"
  }
}

#Preview {
  MyPageView(
    store: Store(
      initialState: MyPageCore.State(
        nickname: "가빵집",
        currentVersion: "0.0.0",
        alarmStatus: .on,
        errorType: .setting,
        errorMessage: "에러",
        popupType: .logout,
        popupTitle: "타이틀",
        popupLeftButtonTitle: "왼쪽",
        popupRightButtonTitle: "오른쪽"
      ),
      reducer: MyPageCore.init
    )
  )
}
