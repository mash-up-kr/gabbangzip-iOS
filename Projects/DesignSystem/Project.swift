import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.make(
  name: "DesignSystem",
  targets: [
    .make(
      name: "DesignSystem",
      product: .framework,
      bundleId: "com.mashup.gabbangzip.designSystem",
      sources: ["Sources/**"],
      resources: ["Resources/**"],
      dependencies: [
        .external(externalDependency: .lottie)
      ]
    )
  ],
  resourceSynthesizers: [
    .custom(name: "Assets", parser: .assets, extensions: ["xcassets"]),
    .custom(name: "JSON", parser: .json, extensions: ["json"])
  ]
)
