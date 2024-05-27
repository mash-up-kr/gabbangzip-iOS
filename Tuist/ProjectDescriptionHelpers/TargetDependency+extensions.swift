//
//  TargetDependency+extensions.swift
//  ProjectDescriptionHelpers
//
//  Created by YangJoonHyeok on 5/26/24.
//

import Foundation
import ProjectDescription

extension TargetDependency {
  public static func external(externalDependency: ExternalDependency) -> TargetDependency {
    return .external(name: externalDependency.rawValue)
  }

  public static func target(name: TargetName) -> TargetDependency {
    return .target(name: name.rawValue)
  }

  public static func project(target: TargetName, projectPath: ProjectPath) -> TargetDependency {
    return .project(
      target: target.rawValue,
      path: .relativeToRoot(projectPath.rawValue)
    )
  }
}

public enum ProjectPath: String {
  case core = "Projects/Core"
  case designSystem = "Projects/DesignSystem"
  case coordinator = "Projects/Features/Coordinator"
  case scene = "Projects/Features/Scene"
}

public enum TargetName: String {
  case models = "Models"
  case services = "Services"
  case coreKit = "CoreKit"
  case designSystem = "DesignSystem"
  case appCoordinator = "AppCoordinator"
  case mainCoordinator = "MainCoordinator"
}

public enum ExternalDependency: String {
  case get = "Get"
  case composableArchitecture = "ComposableArchitecture"
  case tcaCoordinators = "TCACoordinators"
  case nuke = "Nuke"
  case lottie = "Lottie"
}
