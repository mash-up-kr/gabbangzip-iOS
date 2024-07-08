//
//  MyPageView.swift
//  MyPage
//
//  Created by Hyun A Song on 7/5/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import ComposableArchitecture
import DesignSystem
import KakaoLogin
import SwiftUI

public struct MyPageView: View {
  @Bindable public var store: StoreOf<MyPageCore>
  
  public init(store: StoreOf<MyPageCore>) {
    self.store = store
  }
  
  @Environment(\.scenePhase) private var scenePhase
  
  public var body: some View {
    if store.isLoginViewPresented {
      LoginView(
        store: Store(
          initialState: LoginCore.State(),
          reducer: LoginCore.init
        )
      )
    } else {
      VStack {
        NavigationBar(type: .titleWithBackButton(MyPageNameSpace.myPageTitle))
        
        SettingTextView(
          text: store.nickname,
          font: .head20,
          verticalPadding: 16
        )
        
        SeparatorView(height: 16, padding: 16)
        
        SettingTextView(
          text: MyPageNameSpace.alarmSetting,
          font: .head14
        )
        
        Button(
          action: {
            store.send(.openSetting)
          }, label: {
            HStack {
              SettingTextView(text: MyPageNameSpace.appAlarm)
              
              SettingTextView(
                text: store.alarmStatus,
                color: DesignSystem.Colors.gray60,
                alignment: .trailing
              )
            }
          })
        
        SeparatorView(height: 2, padding: 10)
        
        SettingTextView(
          text: MyPageNameSpace.userSetting,
          font: .head14
        )
        
        HStack {
          SettingTextView(text: MyPageNameSpace.version)
          
          SettingTextView(
            text: MyPageNameSpace.currentVersion,
            color: DesignSystem.Colors.gray60,
            alignment: .trailing
          )
        }
        
        Button(
          action: {
            store.send(.showLogout(true))
          }, label: {
            SettingTextView(text: MyPageNameSpace.logout)
          })
        
        
        Button(
          action: {
            store.send(.showWithdraw(true))
          }, label: {
            SettingTextView(text: MyPageNameSpace.withdraw)
          })
        
        Spacer()
      }
      .onChange(of: scenePhase) { _, newScenePhase in
        if newScenePhase == .active {
          store.send(.checkPushOn)
        }
      }
      .popup(
        isPresented: $store.isLogoutPresented,
        title: MyPageNameSpace.Logout.title,
        leftButtonTitle: MyPageNameSpace.Logout.leftButtonTitle,
        leftButtonAction: {
          store.send(.showLogout(false))
        },
        rightButtonTitle: MyPageNameSpace.Logout.rightButtonTitle,
        rightButtonAction: {
          store.send(.logout)
          store.send(.showLogout(false))
        }
      )
      .popup(
        isPresented: $store.isWithdrawPresented,
        title: MyPageNameSpace.Withdraw.title,
        description: MyPageNameSpace.Withdraw.description,
        leftButtonTitle: MyPageNameSpace.Withdraw.leftButtonTitle,
        leftButtonAction: {
          store.send(.showWithdraw(false))
        },
        rightButtonTitle: MyPageNameSpace.Withdraw.rightButtonTitle,
        rightButtonAction: {
          store.send(.withdraw)
          store.send(.showWithdraw(false))
        }
      )
    }
  }
}

// MARK: - CustomView
extension MyPageView {
  private struct SettingTextView: View {
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
  
  private struct SeparatorView: View {
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
}

// MARK: - MyPageNameSpace
extension MyPageView {
  private enum MyPageNameSpace {
    static let myPageTitle = "마이페이지"
    static let alarmSetting = "알림 설정"
    static let appAlarm = "앱 알람 설정"
    static let userSetting = "계정 설정"
    static let version = "현재 버전"
    static let currentVersion = "1.0.0"
    static let logout = "로그아웃"
    static let withdraw = "회원탈퇴"
    
    enum Logout {
      static let title = "로그아웃 하시겠어요?"
      static let leftButtonTitle = "취소"
      static let rightButtonTitle = "로그아웃"
    }
    
    enum Withdraw {
      static let title = "탈퇴하실건가요?"
      static let description = "탈퇴 시 그룹, 활동 내역이\n삭제되며 복구되지 않습니다."
      static let leftButtonTitle = "취소"
      static let rightButtonTitle = "탈퇴하기"
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
