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
        .external(name: "ComposableArchitecture"),
        .external(name: "TCACoordinators")
      ]
    ),
    .make(
      name: "MainCoordinator",
      product: .staticLibrary,
      bundleId: "com.mashup.gabbangzip.mainCoordinator",
      sources: ["MainCoordinator/**"],
      dependencies: [
        .project(target: "Main", path: .relativeToRoot("Projects/Features/Scene")),
        .external(name: "ComposableArchitecture"),
        .external(name: "TCACoordinators")
      ]
    )
  ]
)
