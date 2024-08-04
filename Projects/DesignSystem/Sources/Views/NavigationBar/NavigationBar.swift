//
//  NavigationBar.swift
//  DesignSystem
//
//  Created by GREEN on 6/25/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import SwiftUI

public struct NavigationBar: View {
  private var type: NavigationBarType
  private var isDarkMode: Bool
  // Back 버튼 액션
  private var backButtonAction: () -> Void
  // 하나의 아이콘 액션
  private var oneIconAction: () -> Void
  // 우측 첫번째 아이콘 액션
  private var firstRightIconAction: () -> Void
  // 우측 두번째 아이콘 액션
  private var secondRightIconAction: () -> Void
  // 우측 아이콘 액션 (하나일때)
  private var rightIconAction: () -> Void
  
  public init(
    type: NavigationBarType,
    isDarkMode: Bool = false,
    backButtonAction: @escaping () -> Void = {},
    oneIconAction: @escaping () -> Void = {},
    firstRightIconAction: @escaping () -> Void = {},
    secondRightIconAction: @escaping () -> Void = {},
    rightIconAction: @escaping () -> Void = {}
  ) {
    self.type = type
    self.isDarkMode = isDarkMode
    self.backButtonAction = backButtonAction
    self.oneIconAction = oneIconAction
    self.firstRightIconAction = firstRightIconAction
    self.secondRightIconAction = secondRightIconAction
    self.rightIconAction = rightIconAction
  }
  
  public var body: some View {
    switch type {
    case let .titleWithBackButton(title, alignment):
      TitleWithBackButtonView(
        title: title,
        backButtonAction: backButtonAction,
        isDarkMode: isDarkMode,
        titleAlignment: alignment
      )
    case let .title(title):
      TitleView(title: title)
    case let .logoAndOneIcon(icon):
      LogoAndIconView(
        icon: icon,
        iconAction: oneIconAction
      )
    case let .logoAndTwoIcon(firstIcon, secondIcon):
      LogoAndTwoIconsView(
        firstRightIcon: firstIcon,
        secondRightIcon: secondIcon,
        firstRightIconAction: firstRightIconAction,
        secondRightIconAction: secondRightIconAction
      )
    case let .titleWithBackButtonAndIcon(title, icon):
      TitleWithBackButtonAndIconView(
        title: title,
        rightIcon: icon,
        backButtonIconAction: backButtonAction,
        rightIconAction: rightIconAction
      )
    }
  }
}

// MARK: - BackButton + Title
fileprivate struct TitleWithBackButtonView: View {
  private var title: String
  private var backButtonAction: () -> Void
  private var isDarkMode: Bool
  private var mainColor: Color {
    isDarkMode ? DesignSystem.Colors.gray0 : DesignSystem.Colors.gray100
  }
  private var titleAlignment: NavigationTitleAlignment
  
  fileprivate init(
    title: String,
    backButtonAction: @escaping () -> Void,
    isDarkMode: Bool,
    titleAlignment: NavigationTitleAlignment
  ) {
    self.title = title
    self.backButtonAction = backButtonAction
    self.isDarkMode = isDarkMode
    self.titleAlignment = titleAlignment
  }
  
  fileprivate var body: some View {
    switch titleAlignment {
    case .center:
      ZStack {
        HStack(spacing: 0) {
          Button(
            action: {
              backButtonAction()
            },
            label: {
              DesignSystem.Icons.back
                .resizable()
                .frame(width: 26, height: 26)
                .padding(.vertical, 10)
                .padding(.leading, 16)
                .tint(mainColor)
            }
          )
          
          Spacer()
        }
        
        Text(title)
          .font(.body16)
          .foregroundStyle(mainColor)
      }
      .frame(height: 46)
    case .left:
      HStack(spacing: 6) {
        Button(
          action: {
            backButtonAction()
          },
          label: {
            DesignSystem.Icons.back
              .resizable()
              .frame(width: 26, height: 26)
              .padding(.vertical, 10)
              .padding(.leading, 16)
              .tint(mainColor)
          }
        )
          
        Text(title)
          .font(.body16)
          .foregroundStyle(mainColor)
        
        Spacer()
      }
      .frame(height: 46)
    }
  }
}

// MARK: - Only Title
fileprivate struct TitleView: View {
  private var title: String
  
  fileprivate init(title: String) {
    self.title = title
  }
  
  fileprivate var body: some View {
    HStack(spacing: 0) {
      Text(title)
        .font(.body16)
        .foregroundStyle(DesignSystem.Colors.gray80)
        .padding(.vertical, 15)
    }
    .frame(height: 46)
  }
}

// MARK: - Logo and Icon
fileprivate struct LogoAndIconView: View {
  private var icon: Image
  private var iconAction: () -> Void
  
  fileprivate init(
    icon: Image = DesignSystem.Icons.user,
    iconAction: @escaping () -> Void
  ) {
    self.icon = icon
    self.iconAction = iconAction
  }
  
  fileprivate var body: some View {
    HStack(spacing: 12) {
      DesignSystem.Icons.picLogo
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(height: 26)
        .padding(.leading, 17.5)
      
      Spacer()
      
      Button(
        action: {
          iconAction()
        },
        label: {
          icon
            .resizable()
            .frame(width: 26, height: 26)
        }
      )
      .padding(.trailing, 17.5)
    }
    .frame(height: 56)
  }
}

// MARK: - Logo and Icon
fileprivate struct LogoAndTwoIconsView: View {
  private var firstRightIcon: Image
  private var secondRightIcon: Image
  private var firstRightIconAction: () -> Void
  private var secondRightIconAction: () -> Void
  
  fileprivate init(
    firstRightIcon: Image = DesignSystem.Icons.plus,
    secondRightIcon: Image = DesignSystem.Icons.user,
    firstRightIconAction: @escaping () -> Void,
    secondRightIconAction: @escaping () -> Void
  ) {
    self.firstRightIcon = firstRightIcon
    self.secondRightIcon = secondRightIcon
    self.firstRightIconAction = firstRightIconAction
    self.secondRightIconAction = secondRightIconAction
  }
  
  fileprivate var body: some View {
    HStack(spacing: 12) {
      DesignSystem.Icons.picLogo
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(height: 26)
        .padding(.leading, 17.5)
      
      Spacer()
      
      Button(
        action: {
          firstRightIconAction()
        },
        label: {
          firstRightIcon
            .resizable()
            .frame(width: 26, height: 26)
        }
      )
      
      Button(
        action: {
          secondRightIconAction()
        },
        label: {
          secondRightIcon
            .resizable()
            .frame(width: 26, height: 26)
        }
      )
      .padding(.trailing, 17.5)
    }
    .frame(height: 56)
  }
}

// MARK: - Title + BackButton + Icon
fileprivate struct TitleWithBackButtonAndIconView: View {
  private var title: String
  private var rightIcon: Image
  private var backButtonIconAction: () -> Void
  private var rightIconAction: () -> Void
  
  fileprivate init(
    title: String,
    rightIcon: Image = DesignSystem.Icons.group,
    backButtonIconAction: @escaping () -> Void,
    rightIconAction: @escaping () -> Void
  ) {
    self.title = title
    self.rightIcon = rightIcon
    self.backButtonIconAction = backButtonIconAction
    self.rightIconAction = rightIconAction
  }
  
  fileprivate var body: some View {
    HStack(spacing: 6) {
      Button(
        action: {
          backButtonIconAction()
        },
        label: {
          DesignSystem.Icons.back
            .resizable()
            .frame(width: 26, height: 26)
            .tint(.black)
        }
      )
      .padding(.leading, 17.5)
      
      Text(title)
        .font(.body16)
        .foregroundStyle(DesignSystem.Colors.gray100)
      
      Spacer()
      
      Button(
        action: {
          rightIconAction()
        },
        label: {
          rightIcon
            .resizable()
            .frame(width: 26, height: 26)
        }
      )
      .padding(.trailing, 17.5)
    }
    .frame(height: 56)
  }
}

#Preview {
  VStack(spacing: 10) {
    NavigationBar(type: .titleWithBackButton("그룹 만들기", .center))
    NavigationBar(type: .titleWithBackButton("그룹 만들기", .left), isDarkMode: true)
      .background(.black)
    NavigationBar(type: .title("완료"))
    NavigationBar(type: .logoAndTwoIcon(
      DesignSystem.Icons.plus,
      DesignSystem.Icons.user)
    )
    NavigationBar(type: .titleWithBackButtonAndIcon(
      "뛰뛰빵빵 가빵집😃",
      DesignSystem.Icons.group)
    )
  }
}
