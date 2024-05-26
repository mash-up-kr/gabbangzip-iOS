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
				.target(name: .models)
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
			name: "HomeAPIClient",
			product: .staticLibrary,
			bundleId: "com.mashup.gabbangzip.services.homeapiclient",
			sources: ["Services/HomeAPIClient/**"],
			dependencies: [
				.external(externalDependency: .get),
				.external(externalDependency: .composableArchitecture)
			]
		),
		.make(
			name: "GetHelpers",
			product: .staticLibrary,
			bundleId: "com.mashup.gabbangzip.services.gethelpers",
			sources: ["Services/GetHelpers/**"],
			dependencies: [
				.external(externalDependency: .get)
			]
		),
		.make(
			name: "GabbangzipError",
			product: .staticLibrary,
			bundleId: "com.mashup.gabbangzip.services.gabbangziperror",
			sources: ["Services/GabbangzipError/**"],
			dependencies: []
		)
  ]
)
