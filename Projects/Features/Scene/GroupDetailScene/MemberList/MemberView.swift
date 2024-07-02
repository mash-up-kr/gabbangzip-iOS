//
//  MemberView.swift
//  GroupDetail
//
//  Created by 최혜린 on 6/22/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import SwiftUI

import DesignSystem
import Models

struct MemberView: View {
  let member: Member
  let groupCategory: GroupCategory
  
  var body: some View {
    HStack(spacing: 0) {
      VStack(alignment: .leading, spacing: 8) {
        Text(member.name)
          .font(.body17)
        if member.isLeader {
          Text("그룹장")
            .font(.text14)
        }
      }
      
      Spacer()
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
      groupCategory: .club
    )
  }
}
