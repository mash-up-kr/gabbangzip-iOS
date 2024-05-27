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
        .target(name: .services)
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
				.external(externalDependency: .composableArchitecture)
      ]
    )
  ]
)
