import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.make(
  name: "Scene",
  targets: [
    .make(
      name: "Main",
      product: .framework,
      bundleId: "com.mashup.gabbangzip.main.main",
      sources: ["MainScene/**"],
      dependencies: [
        .project(target: .coreKit, projectPath: .core),
        .project(target: .designSystem, projectPath: .designSystem),
        .external(externalDependency: .composableArchitecture),
        .external(externalDependency: .nukeUI),
        .external(externalDependency: .lottie)
      ]
    ),
    .make(
      name: "KakaoLogin",
      product: .framework,
      bundleId: "com.mashup.gabbangzip.kakaoLogin.kakaoLogin",
      sources: ["KakaoLoginScene/**"],
      dependencies: [
        .project(target: .coreKit, projectPath: .core),
        .project(target: .designSystem, projectPath: .designSystem),
        .external(externalDependency: .composableArchitecture),
        .external(externalDependency: .lottie)
      ]
    ),
    .make(
      name: "GroupDetail",
      product: .framework,
      bundleId: "com.mashup.gabbangzip.groupDetail",
      sources: ["GroupDetailScene/**"],
      dependencies: [
        .project(target: .models, projectPath: .core),
        .project(target: .coreKit, projectPath: .core),
        .project(target: .designSystem, projectPath: .designSystem),
        .external(externalDependency: .composableArchitecture),
        .external(externalDependency: .nukeUI),
        .external(externalDependency: .lottie)
      ]
    )
  ]
)
