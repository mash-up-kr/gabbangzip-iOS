//
//  VoteView.swift
//  GroupDetail
//
//  Created by hyerin on 7/18/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import ComposableArchitecture
import DesignSystem
import SwiftUI

public struct VoteView: View {
  let store: StoreOf<VoteCore>
  
  public init(store: StoreOf<VoteCore>) {
    self.store = store
  }
  
  public var body: some View {
    ZStack {
      DesignSystem.Images.gradientBackground
      
      VStack {
        HStack {
          Spacer()
          
          Button(
            action: {
              // TODO
            }, label: {
              DesignSystem.Icons.close
            }
          )
          .padding(.trailing, 16)
          .padding(.top, 27)
        }
        
        VStack(spacing: 4) {
          DesignSystem.Icons.voteBlack
          
          Text("\(store.name)의 PIC")
            .font(.head18)
          
          // TODO: 투표 이미지
          
          // TODO: 버튼
        }
        
        Spacer()
      }
    }
  }
}

#Preview {
  VoteView(
    store: Store(
      initialState: .init(
        name: "혜린"
      ),
      reducer: VoteCore.init
    )
  )
}
