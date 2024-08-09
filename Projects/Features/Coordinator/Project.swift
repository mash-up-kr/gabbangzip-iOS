import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.make(
  name: "Coordinator",
  targets: [
    .make(
      name: "AppCoordinator",
      product: .staticLibrary,
      bundleId: "com.mashup.gabbangzip.appCoordinator",
      sources: ["AppCoordinator/**"],
      dependencies: [
        .external(externalDependency: .composableArchitecture),
        .external(externalDependency: .tcaCoordinators)
      ]
    ),
    .make(
      name: "MainCoordinator",
      product: .staticLibrary,
      bundleId: "com.mashup.gabbangzip.mainCoordinator",
      sources: ["MainCoordinator/**"],
      dependencies: [
        .project(target: .main, projectPath: .scene),
        .project(target: .myPage, projectPath: .scene),
        .project(target: .login, projectPath: .scene),
        .target(name: .createGroupCoordinator),
        .external(externalDependency: .composableArchitecture),
        .external(externalDependency: .tcaCoordinators),
      ]
    ),
    .make(
      name: "CreateGroupCoordinator",
      product: .staticLibrary,
      bundleId: "com.mashup.gabbangzip.createGroupCoordinator",
      sources: ["CreateGroupCoordinator/**"],
      dependencies: [
        .project(target: .createGroup, projectPath: .scene),
        .external(externalDependency: .composableArchitecture),
        .external(externalDependency: .tcaCoordinators),
      ]
    )
  ]
)
