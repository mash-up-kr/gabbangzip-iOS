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
        .external(externalDependency: .composableArchitecture),
        .external(externalDependency: .tcaCoordinators)
      ]
    )
  ]
)
