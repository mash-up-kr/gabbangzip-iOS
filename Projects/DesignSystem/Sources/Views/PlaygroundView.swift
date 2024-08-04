//
//  PlaygroundView.swift
//  DesignSystem
//
//  Created by YangJoonHyeok on 7/1/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import SwiftUI

struct PlaygroundView: View {
  var body: some View {
    VStack {
      Spacer()
      
      Text("Hello, world!")
      
      Spacer()
    }
    .frame(maxWidth: .infinity)
    .background(Color.secondary)
    .overlay(alignment: .bottomTrailing) {
      FloatingButton(floatingItems: [
        FloatingItem(id: "1", icon: DesignSystem.Icons.plus, title: "Add", action: {}),
        FloatingItem(id: "2", icon: DesignSystem.Icons.plus, title: "Add", action: {})
      ])
        .padding(.trailing, 80)
        .padding(.bottom, 80)
    }
  }
}

struct FloatingButton: View {
  @State var isExpended: Bool
  var floatingItems: [FloatingItem]
  
  init(
    isExpended: Bool = false,
    floatingItems: [FloatingItem] = []
  ) {
    self.isExpended = isExpended
    self.floatingItems = floatingItems
  }
  
  var body: some View {
    VStack(alignment: .trailing) {
      VStack(spacing: 16) {
        ForEach(floatingItems, id: \.id) { item in
          Button(
            action: item.action,
            label: {
              HStack {
                item.icon
                  .resizable()
                  .scaledToFit()
                  .frame(width: 26, height: 26)
                  .foregroundStyle(DesignSystem.Colors.gray80)
                
                Text(item.title)
                  .font(.body16)
                  .foregroundStyle(DesignSystem.Colors.gray80)
              }
              .frame(maxWidth: .infinity, alignment: .leading)
            }
          )
        }
      }
      .frame(width: 168, height: isExpended ? nil : 0, alignment: .leading)
      .padding(.all, 16)
      .background(DesignSystem.Colors.gray0)
      .cornerRadius(16)
      .opacity(isExpended ? 1 : 0)
      
      Button(
        action: {
          withAnimation {
            isExpended.toggle()
          }
        },
        label: {
          DesignSystem.Icons.plus
            .resizable()
            .scaledToFit()
            .padding(.all, 16)
            .frame(width: 54, height: 54)
            .foregroundStyle(isExpended ? DesignSystem.Colors.gray100 : DesignSystem.Colors.gray0)
            .background(isExpended ? DesignSystem.Colors.gray0 : DesignSystem.Colors.gray80)
            .clipShape(Circle())
            .rotationEffect(.degrees(isExpended ? 45 : 0))
        }
      )
    }
  }
}

struct FloatingItem: Identifiable {
  var id: String
  var icon: Image
  var title: String
  var action: () -> Void
  
  init(
    id: String,
    icon: Image,
    title: String,
    action: @escaping () -> Void
  ) {
    self.id = id
    self.icon = icon
    self.title = title
    self.action = action
  }
}

#Preview {
  PlaygroundView()
}
