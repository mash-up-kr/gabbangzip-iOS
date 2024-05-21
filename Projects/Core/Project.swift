import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.make(
  name: "Core",
  targets: [
    .make(
      name: "CoreKit",
      product: .staticLibrary,
      bundleId: "com.mashup.gabbangzip.coreKit",
      sources: ["CoreKit/**"],
      dependencies: [
        .target(name: "Models"),
        .target(name: "Services")
      ]
    ),
    .make(
      name: "Models",
      product: .staticLibrary,
      bundleId: "com.mashup.gabbangzip.models",
      sources: ["Models/**"],
      dependencies: []
    ),
    .make(
      name: "Services",
      product: .staticLibrary,
      bundleId: "com.mashup.gabbangzip.services",
      sources: ["Services/**"],
      dependencies: [
        .target(name: "Models"),
        .external(name: "ComposableArchitecture"),
        .external(name: "Get")
      ]
    ),
  ]
)
