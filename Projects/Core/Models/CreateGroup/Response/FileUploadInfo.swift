//
//  FileUploadInfo.swift
//  Models
//
//  Created by YangJoonHyeok on 7/29/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

public struct FileUploadInfo: Decodable {
  public let uploadURL: String
  public let fileID: String
  public let urlExpTsMillis: Int
  
  enum CodingKeys: String, CodingKey {
    case uploadURL = "upload_url"
    case fileID = "file_id"
    case urlExpTsMillis = "url_exp_ts_millis"
  }
}
