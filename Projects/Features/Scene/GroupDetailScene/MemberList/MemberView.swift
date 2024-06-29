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
  
  var body: some View {
    HStack(spacing: 0) {
      MemberProfileImageView(imageURL: member.imageURL)
        .padding(
          EdgeInsets(top: 0,
          leading: 16,
          bottom: 0,
          trailing: 20)
        )
      
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

struct MemberProfileImageView: View {
  let imageURL: URL
  
  var body: some View {
    AsyncImage(url: imageURL) { image in
      image.resizable()
        .frame(width: 46, height: 46)
        .padding(.vertical, 8)
        .clipShape(Circle())
    } placeholder: {
      Rectangle()
        .frame(width: 46, height: 46)
        .clipShape(Circle())
        .background(DesignSystem.Colors.gray50)
    }
  }
}

#Preview {
  Group {
    MemberView(
      member: Member(
        name: "혜린",
        imageURL: URL(string: "https://thumbnews.nateimg.co.kr/view610///news.nateimg.co.kr/orgImg/ts/2024/05/31/15501274_1325007_402_org.jpg")!,
        isLeader: true
      )
    )
    
    MemberView(
      member: Member(
        name: "혜린",
        imageURL: URL(string: "https://thumbnews.nateimg.co.kr/view610///news.nateimg.co.kr/orgImg/ts/2024/05/31/15501274_1325007_402_org.jpg")!,
        isLeader: false
      )
    )
  }
}
