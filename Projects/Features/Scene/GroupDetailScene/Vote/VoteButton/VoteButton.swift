//
//  VoteButton.swift
//  GroupDetail
//
//  Created by hyerin on 7/18/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import DesignSystem
import SwiftUI

struct VoteButton: View {
  let type: VoteButtonType
  var state: VoteButtonState
  let action: () -> Void

  var body: some View {
    Button(
      action: action,
      label: {
        type.icon
          .foregroundStyle(state == .deactivate ? type.deactivateColor : type.activateColor)
          .frame(width: 60, height: 60)
          .background(
            RoundedRectangle(cornerRadius: 10)
              .foregroundStyle(
                state == .activate ? type.activateBackgroundColor : type.deactivateBackgroundColor
              )
              .shadow(
                color: .black.opacity(0.08),
                radius: 4,
                x: 0,
                y: 4
              )
          )
      }
    )
  }
}

public enum VoteButtonState {
  case defaultState
  case activate
  case deactivate
}

enum VoteButtonType {
  case vote
  case pass
  
  var icon: Image {
    switch self {
    case .vote:
      return DesignSystem.Icons.vote
    case .pass:
      return DesignSystem.Icons.pass
    }
  }

  var activateColor: Color {
    switch self {
    case .vote:
      return DesignSystem.Colors.conifer
    case .pass:
      return DesignSystem.Colors.coral
    }
  }

  var deactivateColor: Color {
    return DesignSystem.Colors.gray60
  }

  var activateBackgroundColor: Color {
    switch self {
    case .vote:
      return DesignSystem.Colors.conifer30
    case .pass:
      return DesignSystem.Colors.coral30
    }
  }

  var deactivateBackgroundColor: Color {
    return DesignSystem.Colors.gray40
  }
}

#Preview {
  Group {
    VoteButton(
      type: .vote,
      state: .defaultState,
      action: {}
    )
    VoteButton(
      type: .pass,
      state: .defaultState,
      action: {}
    )
  }
}
