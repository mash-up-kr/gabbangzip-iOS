const onboarding = require("./grunt/onboarding");
const deployLocal = require("./grunt/deploy-local");

module.exports = function (grunt) {
  grunt.initConfig({
    availabletasks: {
      tasks: {},
    },
  });
  grunt.loadNpmTasks("grunt-available-tasks");

  grunt.registerTask("default", ["availabletasks"]);

  grunt.registerTask("onboarding", "Github Personal AccessToken을 설정합니다.", onboarding);

  grunt.registerTask("deploy", "fastlane을 통해 local에서 배포를 진행합니다.", deployLocal);
};
