import Foundation
import ProjectDescription

fileprivate let commonScripts: [TargetScript] = [
  .pre(
    script: """
    ROOT_DIR=\(ProcessInfo.processInfo.environment["TUIST_ROOT_DIR"] ?? "")
    
    ${ROOT_DIR}/swiftlint --config ${ROOT_DIR}/.swiftlint.yml
    
    """,
    name: "SwiftLint",
    basedOnDependencyAnalysis: false
  )
]

extension Target {
  public static func make(
    name: String,
    destinations: Destinations = [.iPhone],
    product: Product,
    productName: String? = nil,
    bundleId: String,
    deploymentTargets: DeploymentTargets? = nil,
    infoPlist: InfoPlist? = .default,
    sources: SourceFilesList,
    resources: ResourceFileElements? = nil,
    copyFiles: [CopyFilesAction]? = nil,
    headers: Headers? = nil,
    entitlements: Entitlements? = nil,
    scripts: [TargetScript] = [],
    dependencies: [TargetDependency] = [],
    settings: Settings? = nil,
    coreDataModels: [CoreDataModel] = [],
    environmentVariables: [String: EnvironmentVariable] = [:],
    launchArguments: [LaunchArgument] = [],
    additionalFiles: [FileElement] = [],
    buildRules: [BuildRule] = [],
    mergedBinaryType: MergedBinaryType = .disabled,
    mergeable: Bool = false
  ) -> Target {
    return .target(
      name: name,
      destinations: destinations,
      product: product,
      productName: productName,
      bundleId: bundleId,
      deploymentTargets: .iOS("17.0"),
      infoPlist: infoPlist,
      sources: sources,
      resources: resources,
      copyFiles: copyFiles,
      headers: headers,
      entitlements: entitlements,
      scripts: commonScripts + scripts,
      dependencies: dependencies,
      settings: settings,
      coreDataModels: coreDataModels,
      environmentVariables: environmentVariables,
      launchArguments: launchArguments,
      additionalFiles: additionalFiles,
      buildRules: buildRules,
      mergedBinaryType: mergedBinaryType,
      mergeable: mergeable
    )
  }
}
