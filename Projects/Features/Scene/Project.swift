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
<<<<<<< HEAD
      sources: ["KakaoLoginScene/**"],
=======
      sources: ["KakaoLoginScene/KakaoLogin/**"],
>>>>>>> f53630d (feat: UNUserNotificationCenterClient, UIApplicationClient 생성, 앱알림 설정 이동 구현, 앱알림설정에 따라 on/off 토글)
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
    ),
    .make(
      name: "MyPage",
      product: .framework,
      bundleId: "com.mashup.gabbangzip.myPage.myPage",
      sources: ["MyPageScene/**"],
      dependencies: [
        .project(target: .models, projectPath: .core),
        .project(target: .coreKit, projectPath: .core),
        .project(target: .designSystem, projectPath: .designSystem),
        .external(externalDependency: .composableArchitecture)
      ]
    )
  ]
)
