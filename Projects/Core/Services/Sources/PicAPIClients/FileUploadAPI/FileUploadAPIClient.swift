//
//  FileUploadAPIClient.swift
//  Services
//
//  Created by YangJoonHyeok on 7/29/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import ComposableArchitecture
import Foundation
import Get
import Models
import MultipartFormDataKit

@DependencyClient
public struct FileUploadAPIClient: Sendable {
  public var getUploadURL: @Sendable (
    _ accessToken: String,
    _ fileExtension: String
  ) async throws -> FileUploadInfo
  public var uploadFile: @Sendable (
    _ uploadURL: String,
    _ data: Data,
    _ fileExtension: String
  ) async throws -> Void
}

extension FileUploadAPIClient: DependencyKey {
  public static var liveValue: FileUploadAPIClient {
    return FileUploadAPIClient(
      getUploadURL: { accessToken, fileExtension in
        let route = FileUploadAPI.getUploadURL(accessToken: accessToken, fileExtension: fileExtension)
        let request = Request<SuccessResponse<FileUploadInfo>>(route: route)
        do {
          let response = try await NetworkManager.shared.send(request)
          return response.value.data
        } catch {
          throw FileUploadAPIClientError(
            code: .getAPIError,
            underlying: error
          )
        }
      },
      uploadFile: { uploadURL, data, fileExtension in
        guard let uploadURL = URL(string: uploadURL) else {
          throw FileUploadAPIClientError(code: .invalidURL)
        }
        let uuidString = UUID().uuidString
        
        let multipartFormData = try MultipartFormData.Builder.build(
          with: [
            (
              name: "uuidString",
              filename: "\(uuidString).\(fileExtension)",
              mimeType: MIMEType(text: "image/\(fileExtension)"),
              data: data
            )
          ],
          willSeparateBy: RandomBoundaryGenerator.generate()
        )

        let request = Request(
          url: uploadURL,
          method: .put,
          headers: ["Content-Type": multipartFormData.contentType]
        )
        
        do {
          try await NetworkManager.shared.upload(for: request, from: data)
        } catch {
          throw FileUploadAPIClientError(
            code: .getAPIError,
            underlying: error
          )
        }
      }
    )
  }
  
  public static var testValue: FileUploadAPIClient {
    return FileUploadAPIClient()
  }
}

extension DependencyValues {
  public var fileUploadAPIClient: FileUploadAPIClient {
    get { self[FileUploadAPIClient.self] }
    set { self[FileUploadAPIClient.self] = newValue }
  }
}

public struct FileUploadAPIClientError: GabbangzipError {
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
    case invalidURL = 1
  }
}

