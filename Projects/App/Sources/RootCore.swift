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
import Services

@Reducer
public struct RootCore {
  @Reducer
  public enum Destination {
    case mainCoordinator(MainCoordinatorCore)
    case login(LoginCore)
  }
  
  @ObservableState
  public struct State {
    @Presents var destination: Destination.State?
    
    public init(
      destination: Destination.State? = nil
    ) {
      self.destination = destination
    }
  }
  
  public enum Action: BindableAction {
    case binding(BindingAction<State>)
    case destination(PresentationAction<Destination.Action>)
    
    // View Action
    case onAppear
    case onOpenURL(URL)
    
    // Internal Action
    case readUserInfo(Result<UserInfo, Error>)
    case readRefreshToken(Result<String, Error>)
    case checkAccessToken(Result<TestInfo, Error>)
    case refreshToken(Result<TokenInfo, Error>)
    case logError(RootCoreError)
    case setDestination(Destination.State?)
  }
  
  @Dependency(\.authAPIClient) private var authAPIClient
  @Dependency(\.kakaoLoginClient) private var kakaoLoginClient
  @Dependency(\.keyChainClient) private var keyChainClient
  @Dependency(\.userDefaultsClient) private var userDefaultsClient
  
  public var body: some Reducer<State, Action> {
    BindingReducer()
    
    Reduce { state, action in
      switch action {
      case .binding:
        return .none
        
      case .destination(.presented(.mainCoordinator(.router(.routeAction(id: _, action: .myPageCoordinator(.router(.routeAction(id: _, action: .myPage(.backToLogin))))))))):
        state.destination = .login(LoginCore.State())
        return .none
        
      case .destination(.presented(.login(.moveToHome))):
        state.destination = .mainCoordinator(MainCoordinatorCore.State(routes: [.root(.groupList(GroupListCore.State()), embedInNavigationView: true)]))
        return .none
        
      case .destination:
        return .none
        
      case .onAppear:
        return .run { send in
          await send(.readUserInfo(Result { try await self.keyChainClient.readUserInfo() }))
        }
        
      case let .onOpenURL(url):
        return .run { send in
          let isKakaoOpened = kakaoLoginClient.openURL(url)
          
          if !isKakaoOpened {
            await send(.logError(RootCoreError(code: .failToOpenKakao)))
          }
        }
        
      case let .readUserInfo(.success(userInfo)):
        return .run { send in
          await send(.checkAccessToken(Result { try await self.authAPIClient.testToken(userInfo.accessToken) }))
        }
        
      case .readUserInfo(.failure):
        state.destination = .login(LoginCore.State())
        return .none
        
      case let .readRefreshToken(.success(refreshToken)):
        return .run { send in
          await send(.refreshToken(Result { try await self.authAPIClient.refreshToken(refreshToken) }))
        }
        
      case .readRefreshToken(.failure):
        state.destination = .login(LoginCore.State())
        return .none
        
      case .checkAccessToken(.success):
        state.destination = .mainCoordinator(MainCoordinatorCore.State(routes: [.root(.groupList(GroupListCore.State()), embedInNavigationView: true)]))
        return .none
        
      case .checkAccessToken(.failure):
        return .run { send in
          await send(.readRefreshToken(Result { try await self.keyChainClient.readUserInfo().refreshToken }))
        }
        
      case let .refreshToken(.success(tokenInformation)):
        return .run(
          operation: { send in
            var userInfo = try await self.keyChainClient.readUserInfo()
            userInfo.update(keyPath: \.accessToken, value: tokenInformation.accessToken)
            userInfo.update(keyPath: \.refreshToken, value: tokenInformation.refreshToken)
            try await keyChainClient.updateUserInfo(userInfo)
            await send(.setDestination(.mainCoordinator(MainCoordinatorCore.State(routes: [.root(.groupList(GroupListCore.State()), embedInNavigationView: true)]))))
          },
          catch: { error ,send in
            await send(.setDestination(.login(LoginCore.State())))
            await send(.logError(RootCoreError(code: .failToSaveToken)))
          }
        )
        
      case .refreshToken(.failure):
        state.destination = .login(LoginCore.State())
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

