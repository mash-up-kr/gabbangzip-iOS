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
        .project(target: .coreKit, projectPath: .core),
        .project(target: .designSystem, projectPath: .designSystem),
        .project(target: .appCoordinator, projectPath: .coordinator),
        .external(externalDependency: .composableArchitecture)
      ],
      settings: .settings(
        base: [
          "ASSETCATALOG_COMPILER_APPICON_NAME": "ProdAppIcon",
          "DEVELOPMENT_TEAM": "MYR6MP3VKX",
          "CODE_SIGN_STYLE": "Manual",
          "PROVISIONING_PROFILE_SPECIFIER": "match Development com.mashup.gabbangzip",
          "CODE_SIGN_IDENTITY": "Apple Development: Hyerin Choe (QKKN56KGD9)"
        ],
        configurations: [
          .release(name: .release, xcconfig: "./xcconfigs/Gabbangzip.release.xcconfig")
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
        .project(target: .coreKit, projectPath: .core),
        .project(target: .designSystem, projectPath: .designSystem),
        .project(target: .appCoordinator, projectPath: .coordinator),
        .external(externalDependency: .composableArchitecture)
      ],
      settings: .settings(
        base: [
          "ASSETCATALOG_COMPILER_APPICON_NAME": "DevAppIcon",
          "DEVELOPMENT_TEAM": "MYR6MP3VKX",
          "CODE_SIGN_STYLE": "Manual",
          "PROVISIONING_PROFILE_SPECIFIER": "match Development com.mashup.gabbangzip-dev",
          "CODE_SIGN_IDENTITY": "Apple Development: Hyerin Choe (QKKN56KGD9)"
        ],
        configurations: [
          .debug(name: .debug, xcconfig: "./xcconfigs/Gabbangzip.debug.xcconfig")
        ]
      )
    ),
  ],
  additionalFiles: [
    "./xcconfigs/Gabbangzip.shared.xcconfig"
  ]
)
