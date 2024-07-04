//
//  MemberView.swift
//  GroupDetail
//
//  Created by 최혜린 on 6/22/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import DesignSystem
import Models
import SwiftUI

struct MemberView: View {
  private let member: Member
  private let groupCategory: GroupCategory
  
  init(
    member: Member,
    groupCategory: GroupCategory
  ) {
    self.member = member
    self.groupCategory = groupCategory
  }
  
  var body: some View {
    HStack(spacing: 0) {
      logoImageFrom(
        category: groupCategory
      )
      .resizable()
      .frame(width: 24, height: 24)
      .padding(
        EdgeInsets(
          top: 20,
          leading: 24,
          bottom: 20,
          trailing: 16
        )
      )
      
      VStack(alignment: .leading, spacing: 6) {
        Text(member.name)
          .font(.head16)
        if member.isLeader {
          Text("그룹장")
            .font(.text14)
        }
      }
      
      Spacer()
    }
  }
  
  private func logoImageFrom(
    category: GroupCategory
  ) -> Image {
    if let categoryType = CategoryType(rawValue: category.rawValue) {
      return categoryType.selectedImage
    } else {
      return DesignSystem.Images.empty
    }
  }
}

#Preview {
  Group {
    MemberView(
      member: Member.leaderMock,
      groupCategory: .club
    )
    
    MemberView(
      member: Member.notLeaderMock,
      groupCategory: .school
    )
  }
}
