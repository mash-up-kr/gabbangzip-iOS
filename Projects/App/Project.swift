import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.make(
  name: "App",
  targets: [
    .make(
      name: "Prod-Gabbangzip",
      product: .app,
      bundleId: "com.mashup.gabbangzip",
      infoPlist: .file(path: .relativeToRoot("Projects/App/Info.plist")),
      sources: ["Sources/**"],
      resources: ["Resources/**"],
      dependencies: [
        .project(target: "CoreKit", path: .relativeToRoot("Projects/Core")),
        .project(target: "DesignSystem", path: .relativeToRoot("Projects/DesignSystem")),
        .project(target: "AppCoordinator", path: .relativeToRoot("Projects/Features/Coordinator")),
        .external(name: "ComposableArchitecture"),
      ],
      settings: .settings(
        base: [
          "ASSETCATALOG_COMPILER_APPICON_NAME":"ProdAppIcon"
        ],
        configurations: [
          .release(name: .release, xcconfig: "./xcconfigs/Gabbangzip.release.xcconfig"),
        ]
      )
    ),
    .make(
      name: "Dev-Gabbangzip",
      product: .app,
      bundleId: "com.mashup.gabbangzip-dev",
      infoPlist: .file(path: .relativeToRoot("Projects/App/Info.plist")),
      sources: ["Sources/**"],
      resources: ["Resources/**"],
      dependencies: [
        .project(target: "CoreKit", path: .relativeToRoot("Projects/Core")),
        .project(target: "DesignSystem", path: .relativeToRoot("Projects/DesignSystem")),
        .project(target: "AppCoordinator", path: .relativeToRoot("Projects/Features/Coordinator")),
        .external(name: "ComposableArchitecture"),
      ],
      settings: .settings(
        base: [
          "ASSETCATALOG_COMPILER_APPICON_NAME":"DevAppIcon"
        ],
        configurations: [
          .debug(name: .debug, xcconfig: "./xcconfigs/Gabbangzip.debug.xcconfig"),
        ]
      )
    ),
  ],
  additionalFiles: [
    "./xcconfigs/Gabbangzip.shared.xcconfig"
  ]
)
