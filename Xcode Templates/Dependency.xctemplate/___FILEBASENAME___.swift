//___FILEHEADER___

import ComposableArchitecture

@DependencyClient
public struct ___FILEBASENAMEASIDENTIFIER___ {
  
}

extension ___FILEBASENAMEASIDENTIFIER___: DependencyKey {
  public static var liveValue: ___FILEBASENAMEASIDENTIFIER___ {
    return ___FILEBASENAMEASIDENTIFIER___(
      
    )
  }
  
  public static var testValue: ___FILEBASENAMEASIDENTIFIER___ {
    return ___FILEBASENAMEASIDENTIFIER___()
  }
}

extension DependencyValues {
  public var ___FILEBASENAMEASIDENTIFIER___/*소문자로 바꾸기*/: ___FILEBASENAMEASIDENTIFIER___ {
    get { self[___FILEBASENAMEASIDENTIFIER___.self] }
    set { self[___FILEBASENAMEASIDENTIFIER___.self] = newValue }
  }
}

public struct ___FILEBASENAMEASIDENTIFIER___Error: GabbangzipError {
  public var userInfo: [String: Any]
  public var code: APIResponseError
  public var underlying: Error?

  public init(
    userInfo: [String: Any] = [:],
    code: APIResponseError,
    underlying: Error? = nil
  ) {
    self.userInfo = userInfo
    self.code = code
    self.underlying = underlying
  }

  public enum APIResponseError: Int {
    case getAPIError = 0
  }
}

