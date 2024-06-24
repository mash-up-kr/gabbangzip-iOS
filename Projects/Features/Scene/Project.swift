import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.make(
  name: "Scene",
  targets: [
    .make(
      name: "Main",
      product: .staticFramework,
      bundleId: "com.mashup.gabbangzip.main.main",
      sources: ["MainScene/Main/**"],
      dependencies: [
        .project(target: .coreKit, projectPath: .core),
        .project(target: .designSystem, projectPath: .designSystem),
        .external(externalDependency: .composableArchitecture),
        .external(externalDependency: .nuke),
        .external(externalDependency: .lottie)
      ]
    ),
    .make(
      name: "KakaoLogin",
      product: .staticFramework,
      bundleId: "com.mashup.gabbangzip.kakaoLogin.kakaoLogin",
      sources: ["KakaoLoginScene/KakaoLogin/**"],
      dependencies: [
        .project(target: .coreKit, projectPath: .core),
        .project(target: .designSystem, projectPath: .designSystem),
        .external(externalDependency: .composableArchitecture),
        .external(externalDependency: .nuke),
        .external(externalDependency: .lottie)
      ]
    )
  ]
)
