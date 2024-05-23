# 가자 iOS 빵집으로~ 🍞

# 🤖 프로젝트 설정 및 실행
1. `make bootstrap`
  - 최초 클론 시 터미널에서 한번만 실행하면 됩니다.
  - Bundler & fastlane & npm & grunt & mise 설치
  - 설치 중 워닝 시 해당 워닝 메시지 명령어를 기입하여 진행합니다.
2. `make generate`
  - Tuist를 이용한 워크스페이스 및 프로젝트 생성하는 과정입니다.
  - swiftLint를 적용해두어 기존 tuist generate를 사용해도 되지만, 아래와 같이 사용하셔야 합니다.
    `TUIST_ROOT_DIR=$PWD tuist generate`
  - 가급적이면 해당 `make generate`로 프로젝트 생성하시길 권장드립니다.
***
# 🚀 배포하기
### 1️⃣ grunt 명령어를 이용한 배포 및 후속 처리 (사용 권장)
1. 개인 Github personal access tokens 설정을 위한 온보딩
    `grunt onboarding` 
    해당 명령어를 통해 개인 깃헙 토큰을 입력하여 환경 변수에 저장해둡니다.
2. 배포 및 후속처리
    `grunt deploy`
    해당 터미널에 안내되는 스텝에 따라 진행하면 됩니다.
    항상 develop branch가 배포됩니다.
- fastlane 배포 (beta - dev + prod)
- 릴리즈 커밋 자동 생성 및 푸쉬
- 빌드 버전 넘버 업데이트
- 스텝 예시
  1️⃣ Apple Developer 이메일을 입력해 주세요. (ex. humains@nate.com)
    humains@nate.com
  2️⃣ bump type (no, patch, minor, major) 또는 특정 버전(1.1.0)을 입력하세요. / 현재 버전은 1.0.0 입니다.
    patch
  3️⃣ git reset --h 명령어가 실행됩니다. 커밋되지 않은 변경사항은 모두 삭제됩니다. (y/n)
    y

### 2️⃣ fastlane 명령어를 이용한 배포
  - 추후 앱 등록 후 팀 계정 ID 등 환경값 변경 후 사용 가능 (추후 업데이트 예정)
  - Dev / Prod 원하는 앱 배포가 가능합니다.
    `bundle exec fastlane dev || prod || beta(dev + prod)`
  - gabbangzip.shared.xccofing 파일에서 마케팅 버전 수정하여 사용
***