//
//  SelectKeywordCore.swift
//  CreateGroup
//
//  Created by YangJoonHyeok on 7/9/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import ComposableArchitecture
import Models

@Reducer
public struct SelectKeywordCore {
  public init() {}
  
  @ObservableState
  public struct State: Equatable {
    var groupName: String
    var selectedKeyword: GroupData.Keyword
    var schoolKeywordButtonSelected: Bool
    var crewKeywordButtonSelected: Bool
    var companyKeywordButtonSelected: Bool
    var littleMoimKeywordButtonSelected: Bool
    var networkKeywordButtonSelected: Bool
    var exerciseKeywordButtonSelected: Bool
    var hobbyKeywordButtonSelected: Bool
    
    public init(
      groupName: String,
      selectedKeyword: GroupData.Keyword = .school,
      schoolKeywordButtonSelected: Bool = true,
      crewKeywordButtonSelected: Bool = false,
      companyKeywordButtonSelected: Bool = false,
      littleMoimKeywordButtonSelected: Bool = false,
      networkKeywordButtonSelected: Bool = false,
      exerciseKeywordButtonSelected: Bool = false,
      hobbyKeywordButtonSelected: Bool = false
    ) {
      self.groupName = groupName
      self.selectedKeyword = selectedKeyword
      self.schoolKeywordButtonSelected = schoolKeywordButtonSelected
      self.crewKeywordButtonSelected = crewKeywordButtonSelected
      self.companyKeywordButtonSelected = companyKeywordButtonSelected
      self.littleMoimKeywordButtonSelected = littleMoimKeywordButtonSelected
      self.networkKeywordButtonSelected = networkKeywordButtonSelected
      self.exerciseKeywordButtonSelected = exerciseKeywordButtonSelected
      self.hobbyKeywordButtonSelected = hobbyKeywordButtonSelected
    }
  }

  public enum Action {
    // View Action
    case nextButtonTapped
    case backButtonTapped
    case keywordButtonTapped(GroupData.Keyword, Bool)
    
    // Internal Action
    case updateKeywordSelection(keyword: GroupData.Keyword, isSelected: Bool)
    
    // Route Action
    case moveToSelectGroupPhoto(String, GroupData.Keyword)
    case backToSetGroupName
  }

  public var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .nextButtonTapped:
        return .send(.moveToSelectGroupPhoto(state.groupName, state.selectedKeyword))
        
      case .backButtonTapped:
        return .send(.backToSetGroupName)
        
      case let .keywordButtonTapped(keyword, isSelected):
        return .send(.updateKeywordSelection(keyword: keyword, isSelected: isSelected))
        
      case let .updateKeywordSelection(keyword, isSelected):
        state.schoolKeywordButtonSelected = (keyword == .school) && isSelected
        state.crewKeywordButtonSelected = (keyword == .crew) && isSelected
        state.companyKeywordButtonSelected = (keyword == .company) && isSelected
        state.littleMoimKeywordButtonSelected = (keyword == .littleMoim) && isSelected
        state.networkKeywordButtonSelected = (keyword == .network) && isSelected
        state.exerciseKeywordButtonSelected = (keyword == .exercise) && isSelected
        state.hobbyKeywordButtonSelected = (keyword == .hobby) && isSelected
        state.selectedKeyword = keyword
        return .none
        
      case .moveToSelectGroupPhoto:
        return .none
        
      case .backToSetGroupName:
        return .none
      }
    }
  }
}
