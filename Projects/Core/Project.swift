import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.make(
  name: "Core",
  targets: [
    .make(
      name: "CoreKit",
      product: .framework,
      bundleId: "com.mashup.gabbangzip.coreKit",
      sources: ["CoreKit/**"],
      dependencies: [
        .target(name: .services),
        .target(name: .common)
      ]
    ),
    .make(
      name: "Models",
      product: .framework,
      bundleId: "com.mashup.gabbangzip.models",
      sources: ["Models/**"],
      dependencies: []
    ),
    .make(
      name: "Services",
      product: .framework,
      bundleId: "com.mashup.gabbangzip.services",
      sources: ["Services/**"],
      dependencies: [
        .external(externalDependency: .get),
        .external(externalDependency: .composableArchitecture),
        .external(externalDependency: .kakaoSDK),
        .target(name: .models)
      ]
    ),
    .make(
      name: "Common",
      product: .framework,
      bundleId: "com.mashup.gabbangzip.common",
      sources: ["Common/**"],
      dependencies: []
    )
  ]
)
