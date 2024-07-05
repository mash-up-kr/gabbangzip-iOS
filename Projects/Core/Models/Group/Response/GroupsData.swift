//
//  GroupsData.swift
//  Models
//
//  Created by YangJoonHyeok on 7/2/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import Foundation

public struct GroupsData: Decodable, Equatable {
  public let groups: [GroupData]
}

extension GroupsData {
  public static let mock = Self(
    groups: [
      GroupData(
        name: "모임 이름1",
        keyword: .school,
        status: .noPastAndCurrentEvent,
        statusDescription: "최근 업데이트 2일전",
        recentEventDate: "",
        cardFrontImageURL: "https://picsum.photos/200",
        cardBackImages: [
          CardBackImage(
            imageURL: "https://picsum.photos/200",
            frame: .snowman
          )
        ]
      ),
      GroupData(
        name: "모임 이름2",
        keyword: .company,
        status: .beforeMyVote,
        statusDescription: "최근 업데이트 3일전",
        recentEventDate: "2024-07-03T01:22:28.673Z",
        cardFrontImageURL: "https://picsum.photos/200",
        cardBackImages: [
          CardBackImage(
            imageURL: "https://picsum.photos/200",
            frame: .plus
          )
        ]
      ),
      GroupData(
        name: "모임 이름3",
        keyword: .crew,
        status: .afterMyVote,
        statusDescription: "최근 업데이트 1일전",
        recentEventDate: "",
        cardFrontImageURL: "https://picsum.photos/200",
        cardBackImages: [
          CardBackImage(
            imageURL: "https://picsum.photos/200",
            frame: .ghost
          )
        ]
      ),
      GroupData(
        name: "모임 이름4",
        keyword: .exercise,
        status: .beforeMyUpload,
        statusDescription: "최근 업데이트 23432일전",
        recentEventDate: "2024-07-03T01:22:28.673Z",
        cardFrontImageURL: "https://picsum.photos/200",
        cardBackImages: [
          CardBackImage(
            imageURL: "https://picsum.photos/200",
            frame: .clover
          )
        ]
      ),
      GroupData(
        name: "모임 이름5",
        keyword: .network,
        status: .afterMyUpload,
        statusDescription: "최근 업데이트 2232일전",
        recentEventDate: "",
        cardFrontImageURL: "https://picsum.photos/200",
        cardBackImages: [
          CardBackImage(
            imageURL: "https://picsum.photos/200",
            frame: .sexy
          )
        ]
      ),
      GroupData(
        name: "모임 이름6",
        keyword: .school,
        status: .noCurrentEvent,
        statusDescription: "최근 업데이트 21일전",
        recentEventDate: "",
        cardFrontImageURL: "https://picsum.photos/200",
        cardBackImages: [
          CardBackImage(
            imageURL: "https://picsum.photos/200",
            frame: .snowman
          ),
          CardBackImage(
            imageURL: "https://picsum.photos/200",
            frame: .clover
          ),
          CardBackImage(
            imageURL: "https://picsum.photos/200",
            frame: .flower
          ),
          CardBackImage(
            imageURL: "https://picsum.photos/200",
            frame: .ghost
          )
        ]
      ),
      GroupData(
        name: "모임 이름7",
        keyword: .school,
        status: .eventCompleted,
        statusDescription: "최근 업데이트 44일전",
        recentEventDate: "",
        cardFrontImageURL: "https://picsum.photos/200",
        cardBackImages: [
          CardBackImage(
            imageURL: "https://picsum.photos/200",
            frame: .snowman
          ),
          CardBackImage(
            imageURL: "https://picsum.photos/200",
            frame: .sexy
          ),
          CardBackImage(
            imageURL: "https://picsum.photos/200",
            frame: .plus
          ),
          CardBackImage(
            imageURL: "https://picsum.photos/200",
            frame: .hamburger
          )
        ]
      )
    ]
  )
}
