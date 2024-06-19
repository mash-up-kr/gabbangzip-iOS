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
        .target(name: .models),
        .target(name: .services),
        .target(name: .common)
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
				.external(externalDependency: .get),
				.external(externalDependency: .composableArchitecture),
        .external(externalDependency: .kakaoSDK)
      ]
    ),
    .make(
      name: "Common",
      product: .staticLibrary,
      bundleId: "com.mashup.gabbangzip.common",
      sources: ["Common/**"],
      dependencies: []
    )
  ]
)
