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
      product: .framework,
      bundleId: "com.mashup.gabbangzip.kakaoLogin.kakaoLogin",
      sources: ["KakaoLoginScene/KakaoLogin/**"],
      dependencies: [
        .project(target: .coreKit, projectPath: .core),
        .project(target: .designSystem, projectPath: .designSystem),
        .external(externalDependency: .composableArchitecture),
        .external(externalDependency: .nuke),
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
    ),
    .make(
      name: "MyPage",
      product: .framework,
      bundleId: "com.mashup.gabbangzip.myPage.myPage",
      sources: ["MyPageScene/**"],
      dependencies: [
        .project(target: .models, projectPath: .core),
        .project(target: .coreKit, projectPath: .core),
        .project(target: .kakaoLogin, projectPath: .scene),
        .project(target: .designSystem, projectPath: .designSystem),
        .external(externalDependency: .composableArchitecture)
      ]
    )
  ]
)
