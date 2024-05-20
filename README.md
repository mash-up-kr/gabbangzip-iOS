# gabbangzip-iOS

# 프로젝트 설정 및 실행
1. `make bootstrap`
  - 최초 클론 시 터미널에서 한번만 실행하면 됩니다.
  - Bundler & fastlane & mise 설치
2. `make generate`
  - Tuist를 이용한 워크스페이스 및 프로젝트 생성하는 과정입니다.
  - swiftLint를 적용해두어 기존 tuist generate를 사용해도 되지만, 아래와 같이 사용하셔야 합니다.
    `TUIST_ROOT_DIR=$PWD tuist generate`
  - 가급적이면 해당 `make generate`로 프로젝트 생성하시길 권장드립니다.

# 배포
### fastlane을 이용한 배포
  - 추후 앱 등록 후 팀 계정 ID 등 환경값 변경 후 사용 가능 (추후 업데이트 예정)
  - Dev / Prod 원하는 앱 배포가 가능합니다.
    `bundle exec fastlane dev || prod || beta(dev + prod)`
  - gabbangzip.shared.xccofing 파일에서 마케팅 버전 수정하여 사용
  - 추후 스크립트로 일원화 하는 작업 시간나면 할 예정