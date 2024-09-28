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
import WebKit

public struct MyPageView: View {
  @Bindable public var store: StoreOf<MyPageCore>
  @Environment(\.scenePhase) private var scenePhase
  
  public init(store: StoreOf<MyPageCore>) {
    self.store = store
  }
  
  public var body: some View {
    VStack {
      NavigationBar(
        type: .titleWithBackButton(MyPageNameSpace.myPageTitle, .center),
        backButtonAction: {
          store.send(.backToHome)
        }
      )
      
      SettingTitleView(
        text: store.userInfo.nickname,
        font: .head20,
        verticalPadding: 16
      )
      
      SeparatorView(height: 16, padding: 8)
      
      NavigationLink(
        destination:
          AppExplanationView()
          .navigationBarHidden(true)
        ,
        label: {
          SettingTitleView(text: "앱 사용설명서")
        }
      )
      
      SeparatorView(height: 16, padding: 8)
      
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
    .navigationBarHidden(true)
    .onAppear {
      store.send(.checkPushStatus)
      store.send(.checkCurrentVersion)
    }
    .onChange(of: scenePhase) { _, newScenePhase in
      if newScenePhase == .active {
        store.send(.checkCurrentVersion)
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

// MARK: - 앱 설명페이지
fileprivate struct AppExplanationView: View {
  
  @Environment(\.presentationMode) var presentationMode
  
  var body: some View {
    NavigationBar(
      type: .titleWithBackButton("앱 사용설명서", .center),
      backButtonAction: {
        presentationMode.wrappedValue.dismiss()
      }
    )
    AppImageView()
  }
}

// MARK: - 이미지 좌우 터치 뷰
struct AppImageView: View {
  @State private var currentIndex = 0
  let images = [
    DesignSystem.Images.appExplanation1,
    DesignSystem.Images.appExplanation2,
    DesignSystem.Images.appExplanation3,
    DesignSystem.Images.appExplanation4,
    DesignSystem.Images.appExplanation5,
    DesignSystem.Images.appExplanation6,
    DesignSystem.Images.appExplanation7,
    DesignSystem.Images.appExplanation8,
    DesignSystem.Images.appExplanation9,
    DesignSystem.Images.appExplanation10
  ]
  
  var body: some View {
    GeometryReader { geo in
      images[currentIndex]
        .resizable()
        .scaledToFit()
        .frame(width: geo.size.width, height: geo.size.height)
        .contentShape(Rectangle())
        .onTapGesture { location in
          let halfWidth = geo.size.width / 2
          if location.x < halfWidth && currentIndex > 0 {
            currentIndex -= 1
          } else if location.x >= halfWidth && currentIndex < images.count - 1 {
            currentIndex += 1
          }
        }
    }
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
      initialState: .init(),
      reducer: MyPageCore.init
    )
  )
}
