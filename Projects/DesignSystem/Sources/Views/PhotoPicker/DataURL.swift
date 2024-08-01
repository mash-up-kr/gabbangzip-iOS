//
//  DataURL.swift
//  DesignSystem
//
//  Created by YangJoonHyeok on 8/2/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import SwiftUI

struct DataUrl: Transferable {
  let url: URL
  
  static var transferRepresentation: some TransferRepresentation {
    FileRepresentation(
      contentType: .data,
      exporting: { data in
        SentTransferredFile(data.url)
      },
      importing: { received in
        Self(url: received.file)
      }
    )
  }
}
