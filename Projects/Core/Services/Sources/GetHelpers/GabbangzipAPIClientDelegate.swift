//
//  GabbangzipAPIClientDelegate.swift
//  Services
//
//  Created by YangJoonHyeok on 5/27/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import Common
import Foundation
import Get
import Models

class GabbangzipAPIClientDelegate: APIClientDelegate {
  func client(
    _ client: APIClient,
    validateResponse response: HTTPURLResponse,
    data: Data,
    task: URLSessionTask
  ) throws {
    let failureResponse = try? JSONDecoder().decode(FailureResponse.self, from: data)
    let rawData = String(data: data, encoding: .utf8) ?? "Decoding data to string failed"
    
    #if DEBUG
    logger.debug("------------------------------------------------------------------------")
    logger.debug("\nHTTP Headers❓\n\(task.currentRequest?.allHTTPHeaderFields?.description ?? "No HTTP Headers")\n")
    logger.debug("\nHTTP Method❓\n\(task.currentRequest?.httpMethod?.description ?? "No HTTP Method")\n")
    logger.debug("\nHTTP Body❓\n\(task.currentRequest?.httpBody?.description ?? "No HTTP Body")\n")
    logger.debug("\nURL❓\n\(task.currentRequest?.url?.absoluteString ?? "No URL")\n")
    logger.debug("\nResponse❓\n\(rawData)\n")
    logger.debug("------------------------------------------------------------------------")
    #endif
    
    switch response.statusCode {
    case 400..<500:
      throw NetworkManagerError(
        userInfo: [
          "response": response,
          "message": failureResponse ?? rawData
        ],
        code: .clientError
      )
      
    case 500..<600:
      throw NetworkManagerError(
        userInfo: [
          "response": response,
          "message": failureResponse ?? rawData
        ],
        code: .serverError
      )
      
    default:
      break
    }
  }
  
  func client(
    _ client: APIClient,
    shouldRetry task: URLSessionTask,
    error: Error,
    attempts: Int
  ) async throws -> Bool {
    throw NetworkManagerError(
      userInfo: [
        "originalRequest": task.originalRequest ?? "",
        "currentRequest": task.currentRequest ?? "",
        "response": task.response ?? "",
        "attemps": attempts
      ],
      code: .networkingFailed,
      underlying: error
    )
  }
}
