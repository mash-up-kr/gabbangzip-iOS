//
//  GroupGridItemCore.swift
//  Main
//
//  Created by YangJoonHyeok on 9/25/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import ComposableArchitecture
import DesignSystem
import Lovebug
import Models
import NukeUI
import SwiftUI

@Reducer
public struct GroupGridItemCore {
  public init() {}

  @ObservableState
  public struct State: Equatable, Identifiable {
    public var id: Int
    var name: String
    var keyword: GroupData.Keyword
    var statusDescription: String
    var cardFrontImageURL: String
    var s3BucketDomain: String
    
    public init(
      id: Int,
      name: String,
      keyword: GroupData.Keyword,
      statusDescription: String,
      cardFrontImageURL: String,
      s3BucketDomain: String = ""
    ) {
      self.id = id
      self.name = name
      self.keyword = keyword
      self.statusDescription = statusDescription
      self.cardFrontImageURL = cardFrontImageURL
      self.s3BucketDomain = s3BucketDomain
    }
  }

  public enum Action {
  }

  public var body: some Reducer<State, Action> {
    Reduce { state, action in
      return .none
    }
  }
}
