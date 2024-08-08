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
        .project(target: .lovebug, projectPath: .scene),
        .external(externalDependency: .composableArchitecture),
        .external(externalDependency: .nukeUI),
        .external(externalDependency: .lottie)
      ]
    ),
    .make(
      name: "Login",
      product: .framework,
      bundleId: "com.mashup.gabbangzip.login.login",
      sources: ["LoginScene/Login/**"],
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
        .project(target: .lovebug, projectPath: .scene),
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
        .project(target: .login, projectPath: .scene),
        .project(target: .designSystem, projectPath: .designSystem),
        .external(externalDependency: .composableArchitecture)
      ]
    ),
    .make(
      name: "CreateGroup",
      product: .framework,
      bundleId: "com.mashup.gabbangzip.createGroup",
      sources: ["CreateGroupScene/**"],
      dependencies: [
        .project(target: .coreKit, projectPath: .core),
        .project(target: .designSystem, projectPath: .designSystem),
        .project(target: .lovebug, projectPath: .scene),
        .external(externalDependency: .composableArchitecture),
        .external(externalDependency: .nukeUI),
        .external(externalDependency: .lottie),
      ]
    ),
    .make(
      name: "CreateEvent",
      product: .framework,
      bundleId: "com.mashup.gabbangzip.createEvent",
      sources: ["CreateEventScene/**"],
      dependencies: [
        .project(target: .coreKit, projectPath: .core),
        .project(target: .designSystem, projectPath: .designSystem),
        .external(externalDependency: .composableArchitecture),
        .external(externalDependency: .nukeUI),
        .external(externalDependency: .lottie),
      ]
    ),
    .make(
      name: "Lovebug",
      product: .framework,
      bundleId: "com.mashup.gabbangzip.lovebug",
      sources: ["Lovebug/**"],
      dependencies: [
        .project(target: .models, projectPath: .core),
        .project(target: .designSystem, projectPath: .designSystem),
        .external(externalDependency: .nukeUI)
      ]
    )
  ]
)
