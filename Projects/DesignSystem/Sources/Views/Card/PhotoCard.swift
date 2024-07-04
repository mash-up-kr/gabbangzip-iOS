//
//  PhotoCard.swift
//  DesignSystem
//
//  Created by YangJoonHyeok on 7/2/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import SwiftUI

public struct PhotoCard<Content: View>: View {
  private var status: Status
  private var content: Content
  
  public init(
    status: Status,
    content: () -> Content
  ) {
    self.status = status
    self.content = content()
  }
  
  public var body: some View {
    VStack(spacing: 0) {
      horizontalIconBar
      
      content
      
      horizontalIconBar
    }
    .padding(.vertical, 20)
    .background(status.backgroundColor)
    .cornerRadius(20)
    .overlay {
      RoundedRectangle(cornerRadius: 20)
        .strokeBorder(DesignSystem.Colors.gray0, lineWidth: 2)
    }
    .shadow(color: DesignSystem.Colors.gray100.opacity(0.06), radius: 20, x: 0, y: 0)
  }
  
  private var horizontalIconBar: some View {
    HStack(spacing: 0) {
      icon
      
      Spacer()
      
      icon
    }
    .padding(.horizontal, 22)
  }
  
  private var icon: some View {
    status.icon
      .resizable()
      .aspectRatio(contentMode: .fit)
      .frame(width: 10, height: 10)
  }
}

extension PhotoCard {
  public enum Status {
    case school
    case company
    case crew
    case network
    case exercise
    case hobby
    case littleMoim
    
    fileprivate var icon: Image {
      switch self {
      case .school:
        return DesignSystem.Icons.schoolActive
      case .company:
        return DesignSystem.Icons.companyActive
      case .crew:
        return DesignSystem.Icons.crewActive
      case .network:
        return DesignSystem.Icons.networkActive
      case .exercise:
        return DesignSystem.Icons.exerciseActive
      case .hobby:
        return DesignSystem.Icons.hobbyActive
      case .littleMoim:
        return DesignSystem.Icons.littleMoimActive
      }
    }
    
    fileprivate var backgroundColor: Color {
      switch self {
      case .school:
        return DesignSystem.Colors.conifer30
      case .company:
        return DesignSystem.Colors.magentaPink30
      case .crew:
        return DesignSystem.Colors.mayaBlue30
      case .network:
        return DesignSystem.Colors.coral30
      case .exercise:
        return DesignSystem.Colors.dandelion30
      case .hobby:
        return DesignSystem.Colors.malibu30
      case .littleMoim:
        return DesignSystem.Colors.lavender30
      }
    }
  }
}

#Preview {
  ScrollView {
    VStack {
      PhotoCard(status: .company) {
        VStack(spacing: 9) {
          HStack(spacing: 9) {
            DesignSystem.Icons.ghostFrame
              .resizable()
              .aspectRatio(contentMode: .fit)
              .foregroundStyle(DesignSystem.Colors.magentaPink30)
              .background(DesignSystem.Colors.gray0)
            
            DesignSystem.Icons.ghostFrame
              .resizable()
              .aspectRatio(contentMode: .fit)
              .foregroundStyle(DesignSystem.Colors.magentaPink30)
              .background(DesignSystem.Colors.gray0)
          }
          
          HStack {
            DesignSystem.Icons.ghostFrame
              .resizable()
              .aspectRatio(contentMode: .fit)
              .foregroundStyle(DesignSystem.Colors.magentaPink30)
              .background(DesignSystem.Colors.gray0)
            
            DesignSystem.Icons.ghostFrame
              .resizable()
              .aspectRatio(contentMode: .fit)
              .foregroundStyle(DesignSystem.Colors.magentaPink30)
              .background(DesignSystem.Colors.gray0)
          }
        }
        .padding(.horizontal, 30)
        .padding(.vertical, 44)
      }
      
      PhotoCard(status: .network) {
        DesignSystem.Icons.plusFrame
          .resizable()
          .aspectRatio(contentMode: .fit)
          .foregroundStyle(DesignSystem.Colors.coral30)
          .background(DesignSystem.Colors.gray0)
          .padding(.horizontal, 30)
          .padding(.vertical, 44)
      }
      
      PhotoCard(status: .school) {
        DesignSystem.Icons.snowmanFrame
          .resizable()
          .aspectRatio(contentMode: .fit)
          .foregroundStyle(DesignSystem.Colors.conifer30)
          .background(DesignSystem.Colors.gray0)
          .padding(.horizontal, 30)
          .padding(.vertical, 44)
      }
      
      PhotoCard(status: .littleMoim) {
        DesignSystem.Icons.cloverFrame
          .resizable()
          .aspectRatio(contentMode: .fit)
          .foregroundStyle(DesignSystem.Colors.lavender30)
          .background(DesignSystem.Colors.gray0)
          .padding(.horizontal, 30)
          .padding(.vertical, 44)
      }
      
      PhotoCard(status: .exercise) {
        DesignSystem.Icons.sexyFrame
          .resizable()
          .aspectRatio(contentMode: .fit)
          .foregroundStyle(DesignSystem.Colors.dandelion30)
          .background(DesignSystem.Colors.gray0)
          .padding(.horizontal, 30)
          .padding(.vertical, 44)
      }
      
      PhotoCard(status: .hobby) {
        DesignSystem.Icons.flowerFrame
          .resizable()
          .aspectRatio(contentMode: .fit)
          .foregroundStyle(DesignSystem.Colors.malibu30)
          .background(DesignSystem.Colors.gray0)
          .padding(.horizontal, 30)
          .padding(.vertical, 44)
      }
      
      PhotoCard(status: .crew) {
        DesignSystem.Icons.hamburgerFrame
          .resizable()
          .aspectRatio(contentMode: .fit)
          .foregroundStyle(DesignSystem.Colors.mayaBlue30)
          .background(DesignSystem.Colors.gray0)
          .padding(.horizontal, 30)
          .padding(.vertical, 44)
      }
    }
    .padding(.horizontal, 80)
  }
}
