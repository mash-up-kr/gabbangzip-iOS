import ProjectDescription

extension Project {
  public static func make(
    name: String,
    organizationName: String? = nil,
    options: [Options]? = nil,
    packages: [Package] = [],
    settings: Settings? = nil,
    targets: [Target] = [],
    schemes: [Scheme] = [],
    fileHeaderTemplate: FileHeaderTemplate? = nil,
    additionalFiles: [FileElement] = [],
    resourceSynthesizers: [ResourceSynthesizer] = .default
  ) -> Project {
    return Project(
      name: name,
      organizationName: "com.mashup.gabbangzip",
      options: .options(
        automaticSchemesOptions: .disabled,
        defaultKnownRegions: ["ko"],
        developmentRegion: "ko",
        textSettings: .textSettings(usesTabs: false, indentWidth: 2, tabWidth: 2)
      ),
      packages: packages,
      settings: settings,
      targets: targets,
      schemes: schemes,
      fileHeaderTemplate: fileHeaderTemplate,
      additionalFiles: additionalFiles,
      resourceSynthesizers: resourceSynthesizers
    )
  }
}
