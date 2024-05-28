// swift-tools-version: 5.9
import PackageDescription

#if TUIST
  import ProjectDescription

  let packageSettings = PackageSettings(
    productTypes: [
      "ComposableArchitecture": .framework,
      "TCACoordinators": .framework,
      "Nuke": .framework,
      "Lottie": .framework,
      "Get": .framework
    ]
  )
#endif

let package = Package(
  name: "Gabbangzip",
  dependencies: [
    .package(url: "https://github.com/pointfreeco/swift-composable-architecture.git", exact: "1.8.0"),
		.package(url: "https://github.com/johnpatrickmorgan/TCACoordinators", from: "0.10.0"),
		.package(url: "https://github.com/kean/Nuke.git", from: "12.0.0"),
		.package(url: "https://github.com/airbnb/lottie-ios.git", from: "4.4.3"),
		.package(url: "https://github.com/kean/Get.git", from: "2.2.0"),
		.package(url: "https://github.com/Kuniwak/MultipartFormDataKit.git", from: "1.0.1")
  ]
)
