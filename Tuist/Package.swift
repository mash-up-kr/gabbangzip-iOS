// swift-tools-version: 5.9
import PackageDescription

#if TUIST
  import ProjectDescription

  let packageSettings = PackageSettings(
    productTypes: [
      "TCA": .framework,
      "Nuke": .framework,
      "Lottie": .framework,
      "Get": .framework
    ]
  )
#endif

let package = Package(
  name: "MyApp",
  dependencies: [
    .package(url: "https://github.com/pointfreeco/swift-composable-architecture.git", from: "1.10.0"),
    .package(url: "https://github.com/kean/Nuke.git", from: "12.0.0"),
    .package(url: "https://github.com/airbnb/lottie-ios.git", from: "4.4.3"),
    .package(url: "https://github.com/kean/Get.git", from: "2.2.0")
  ]
)
