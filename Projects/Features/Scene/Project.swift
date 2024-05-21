import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.make(
  name: "Scene",
  targets: [
    .make(
      name: "Main",
      product: .staticLibrary,
      bundleId: "com.mashup.gabbangzip.main.main",
      sources: ["MainScene/Main/**"],
      dependencies: [
        .project(target: "CoreKit", path: .relativeToRoot("Projects/Core")),
        .project(target: "DesignSystem", path: .relativeToRoot("Projects/DesignSystem")),
        .external(name: "ComposableArchitecture"),
        .external(name: "Nuke"),
        .external(name: "Lottie")
      ]
    )
  ]
)
