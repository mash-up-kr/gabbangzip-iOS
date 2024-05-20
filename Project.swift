import ProjectDescription

let project = Project(
  name: "MyApp",
  targets: [
    .target(
      name: "MyApp",
      destinations: .iOS,
      product: .app,
      bundleId: "io.tuist.MyApp",
      infoPlist: .extendingDefault(
        with: [
          "UILaunchStoryboardName": "LaunchScreen.storyboard",
        ]
      ),
      sources: ["MyApp/Sources/**"],
      resources: ["MyApp/Resources/**"],
      dependencies: [
        .external(name: "TCA"),
        .external(name: "TCACoordinator"),
        .external(name: "Nuke"),
        .external(name: "Lottie"),
        .external(name: "Get")
      ]
    ),
  ]
)
