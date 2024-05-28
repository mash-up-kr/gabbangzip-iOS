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
				.project(target: .coreKit, projectPath: .core),
				.project(target: .designSystem, projectPath: .designSystem),
				.external(externalDependency: .composableArchitecture),
				.external(externalDependency: .nuke),
				.external(externalDependency: .lottie)
      ]
    )
  ]
)
