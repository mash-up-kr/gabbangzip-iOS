//
//  RootCore.swift
//  App
//
//  Created by Hyun A Song on 6/19/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import Common
import ComposableArchitecture
import Foundation
import KakaoSDKUser
import Login
import Main
import MainCoordinator
import Models
import Onboarding
import Services

@Reducer
public struct RootCore {
  @Reducer
  public enum Destination {
    case mainCoordinator(MainCoordinatorCore)
    case onboarding(OnboardingCore)
    case login(LoginCore)
  }
  
  @ObservableState
  public struct State {
    @Presents var destination: Destination.State?
    @Shared var userInfo: UserInfo
    
    public init(
      destination: Destination.State? = nil,
      userInfo: @autoclosure () -> UserInfo = .defaultValue
    ) {
      self.destination = destination
      self._userInfo = Shared(wrappedValue: userInfo(), .inMemory("userInfo"))
    }
  }
  
  public enum Action: BindableAction {
    case binding(BindingAction<State>)
    case destination(PresentationAction<Destination.Action>)
    
    // View Action
    case onAppear
    case onOpenURL(URL)
    
    // Internal Action
    case verifyFirstLaunch(Result<String, Error>)
    case updateAppVersion(String)
    case showOnboarding
    case getUserInfoFromKeyChain(Result<UserInfo, Error>)
    case checkAccessToken(Result<TestInfo, Error>, userInfo: UserInfo)
    case refreshToken(Result<TokenInfo, Error>, userInfo: UserInfo)
    case getGroupsResponse(Result<GroupsData, Error>)
    case setDestination(Destination.State?)
    case logError(RootCoreError)
  }
  
  @Dependency(\.authAPIClient) private var authAPIClient
  @Dependency(\.bundleClient) private var bundleClient
  @Dependency(\.kakaoLoginClient) private var kakaoLoginClient
  @Dependency(\.keyChainClient) private var keyChainClient
  @Dependency(\.userDefaultsClient) private var userDefaultsClient
  @Dependency(\.groupAPIClient) private var groupAPIClient
  
  public var body: some Reducer<State, Action> {
    BindingReducer()
    
    Reduce { state, action in
      switch action {
      case .binding:
        return .none
        
      case .destination(.presented(.onboarding(.moveToLogin))):
        state.destination = .login(LoginCore.State())
        return .none
        
      case .destination(.presented(.mainCoordinator(.router(.routeAction(id: _, action: .myPage(.backToLogin)))))):
        state.destination = .login(LoginCore.State())
        return .none
        
      case .destination(.presented(.login(.moveToHome))):
        state.destination = .mainCoordinator(MainCoordinatorCore.State(routes: [.root(.home(HomeCore.State()), embedInNavigationView: true)]))
        return .none
        
      case .destination(.presented(.login(.moveToGetStarted))):
        state.destination = .mainCoordinator(MainCoordinatorCore.State(routes: [.root(.getStarted(.init()), embedInNavigationView: true)]))
        return .none
        
      case .destination:
        return .none
        
      case .onAppear:
        return .run { send in
          await send(.verifyFirstLaunch(Result { try await self.keyChainClient.readAppVersion() }))
        }
        
      case let .onOpenURL(url):
        return .run { send in
          let isKakaoOpened = kakaoLoginClient.openURL(url)
          
          if !isKakaoOpened {
            await send(.logError(RootCoreError(code: .failToOpenKakao)))
          }
        }
        
      case let .verifyFirstLaunch(.success(savedAppVersion)):
        return .run { send in
          let currentVersion = try bundleClient.getCurrentVersion()
          
          if savedAppVersion == currentVersion {
            await send(.getUserInfoFromKeyChain(Result { try await self.keyChainClient.readUserInfo() }))
          } else {
            await send(.updateAppVersion(currentVersion))
          }
        }
        
      case .verifyFirstLaunch(.failure):
        return .run { send in
          let currentVersion = try bundleClient.getCurrentVersion()
          
          try await self.keyChainClient.createAppVersion(currentVersion)
          await send(.showOnboarding)
        }
        
      case let .updateAppVersion(version):
        return .run { send in
          try await self.keyChainClient.updateAppVersion(version)
          await send(.showOnboarding)
        }
        
      case .showOnboarding:
        state.destination = .onboarding(OnboardingCore.State())
        return .none
        
      case let .getUserInfoFromKeyChain(.success(userInfo)):
        return .run { send in
          await send(
            .checkAccessToken(
              Result { try await self.authAPIClient.testToken(userInfo.accessToken) }, 
              userInfo: userInfo
            )
          )
        }
        
      case .getUserInfoFromKeyChain(.failure):
        state.destination = .login(LoginCore.State())
        return .none
        
      case let .checkAccessToken(.success, userInfo):
        state.userInfo = userInfo
        return .run { send in
          await send(.getGroupsResponse(Result {
            try await self.groupAPIClient.getGroups(userInfo.accessToken)
          }))
        }
        
      case let .checkAccessToken(.failure, userInfo):
        return .run { send in
          await send(
            .refreshToken(
              Result { try await self.authAPIClient.refreshToken(userInfo.refreshToken) },
              userInfo: userInfo)
          )
        }
        
      case let .refreshToken(.success(tokenInformation), userInfo):
        var newUserInfo = userInfo
        newUserInfo.update(keyPath: \.accessToken, value: tokenInformation.accessToken)
        newUserInfo.update(keyPath: \.refreshToken, value: tokenInformation.refreshToken)
        state.userInfo = newUserInfo
        
        return .run(
          operation: { [newUserInfo] send in
            try await keyChainClient.updateUserInfo(newUserInfo)
            await send(.getGroupsResponse(Result {
              try await self.groupAPIClient.getGroups(newUserInfo.accessToken)
            }))
          },
          catch: { error, send in
            await send(.setDestination(.login(LoginCore.State())))
            await send(.logError(RootCoreError(code: .failToSaveToken)))
          }
        )
        
      case .refreshToken(.failure, _):
        state.destination = .login(LoginCore.State())
        return .none
        
      case let .getGroupsResponse(.success(groupsData)):
        let isMemberOfAnyGroup = !groupsData.groups.isEmpty
        if isMemberOfAnyGroup {
          state.destination = .mainCoordinator(MainCoordinatorCore.State(routes: [.root(.home(HomeCore.State()), embedInNavigationView: true)]))
        } else {
          state.destination = .mainCoordinator(MainCoordinatorCore.State(routes: [.root(.getStarted(GetStartedCore.State()), embedInNavigationView: true)]))
        }
        
        return .none
        
      case .getGroupsResponse(.failure):
        state.destination = .mainCoordinator(MainCoordinatorCore.State(routes: [.root(.home(HomeCore.State()), embedInNavigationView: true)]))
        return .none
        
      case let .logError(error):
        return .run { send in
          logger.error("RootCore Error: \(error)")
        }
        
      case let .setDestination(destination):
        state.destination = destination
        return .none
      }
    }
    .ifLet(\.$destination, action: \.destination)
  }
}

// MARK: - RootCoreError
public struct RootCoreError: GabbangzipError {
  public var userInfo: [String: Any] = [:]
  public var code: Code
  public var underlying: Error?
  
  public enum Code: Int {
    case failToOpenKakao
    case failToSaveToken
  }
}

