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
    var schoolKeywordButtonSelected: Bool
    var crewKeywordButtonSelected: Bool
    var companyKeywordButtonSelected: Bool
    var littleMoimKeywordButtonSelected: Bool
    var networkKeywordButtonSelected: Bool
    var exerciseKeywordButtonSelected: Bool
    var hobbyKeywordButtonSelected: Bool
    
    public init(
      groupName: String,
      schoolKeywordButtonSelected: Bool = true,
      crewKeywordButtonSelected: Bool = false,
      companyKeywordButtonSelected: Bool = false,
      littleMoimKeywordButtonSelected: Bool = false,
      networkKeywordButtonSelected: Bool = false,
      exerciseKeywordButtonSelected: Bool = false,
      hobbyKeywordButtonSelected: Bool = false
    ) {
      self.groupName = groupName
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
    case schoolKeywordButtonTapped(Bool)
    case crewKeywordButtonTapped(Bool)
    case companyKeywordButtonTapped(Bool)
    case littleMoimKeywordButtonTapped(Bool)
    case networkKeywordButtonTapped(Bool)
    case exerciseKeywordButtonTapped(Bool)
    case hobbyKeywordButtonTapped(Bool)
    
    // Internal Action
    case updateKeywordSelection(keyword: GroupData.Keyword, isSelected: Bool)
    
    // Route Action
    case moveToSelectGroupPhoto
    case backToSetGroupName
  }

  public var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .nextButtonTapped:
        return .send(.moveToSelectGroupPhoto)
        
      case .backButtonTapped:
        return .send(.backToSetGroupName)
        
      case let .schoolKeywordButtonTapped(isSelected):
        return .send(.updateKeywordSelection(keyword: .school, isSelected: isSelected))
        
      case let .crewKeywordButtonTapped(isSelected):
        return .send(.updateKeywordSelection(keyword: .crew, isSelected: isSelected))
        
      case let .companyKeywordButtonTapped(isSelected):
        return .send(.updateKeywordSelection(keyword: .company, isSelected: isSelected))
        
      case let .littleMoimKeywordButtonTapped(isSelected):
        return .send(.updateKeywordSelection(keyword: .littleMoim, isSelected: isSelected))
        
      case let .networkKeywordButtonTapped(isSelected):
        return .send(.updateKeywordSelection(keyword: .network, isSelected: isSelected))
        
      case let .exerciseKeywordButtonTapped(isSelected):
        return .send(.updateKeywordSelection(keyword: .exercise, isSelected: isSelected))
        
      case let .hobbyKeywordButtonTapped(isSelected):
        return .send(.updateKeywordSelection(keyword: .hobby, isSelected: isSelected))
        
      case let .updateKeywordSelection(keyword, isSelected):
        state.schoolKeywordButtonSelected = (keyword == .school) && isSelected
        state.crewKeywordButtonSelected = (keyword == .crew) && isSelected
        state.companyKeywordButtonSelected = (keyword == .company) && isSelected
        state.littleMoimKeywordButtonSelected = (keyword == .littleMoim) && isSelected
        state.networkKeywordButtonSelected = (keyword == .network) && isSelected
        state.exerciseKeywordButtonSelected = (keyword == .exercise) && isSelected
        state.hobbyKeywordButtonSelected = (keyword == .hobby) && isSelected
        return .none
        
      case .moveToSelectGroupPhoto:
        return .none
        
      case .backToSetGroupName:
        return .none
      }
    }
  }
}
