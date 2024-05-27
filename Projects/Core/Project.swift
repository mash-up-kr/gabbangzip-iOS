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
      sources: ["Services/*"],
      dependencies: [
        .target(name: .getHelpers),
        .target(name: .gabbangzipError)
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
    ),
  ]
)
