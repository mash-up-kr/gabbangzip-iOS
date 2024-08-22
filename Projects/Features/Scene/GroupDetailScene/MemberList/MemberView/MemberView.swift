//
//  MemberView.swift
//  GroupDetail
//
//  Created by 최혜린 on 6/22/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import Common
import DesignSystem
import Models
import SwiftUI

struct MemberView: View {
  private let member: Member
  private let groupKeyword: GroupData.Keyword
  
  init(
    member: Member,
    groupKeyword: GroupData.Keyword
  ) {
    self.member = member
    self.groupKeyword = groupKeyword
  }
  
  var body: some View {
    HStack(spacing: 0) {
      groupKeyword.categoryType.selectedImage
      .resizable()
      .frame(width: 24, height: 24)
      .padding(.init(top: 20, leading: 24, bottom: 20, trailing: 16))
      
      // TEST: - 앱 심사용 테스트 코드
      if member.nickname == "테스트계정" && Bool.forAppReview {
        Text("방장 ⭐️")
          .font(.head16)
          .foregroundStyle(DesignSystem.Colors.gray80)
      } else {
        Text(member.nickname)
          .font(.head16)
          .foregroundStyle(DesignSystem.Colors.gray80)
      }
      
      Spacer()
    }
  }
}

#Preview {
  Group {
    MemberView(
      member: .mock,
      groupKeyword: .company
    )
  }
}
