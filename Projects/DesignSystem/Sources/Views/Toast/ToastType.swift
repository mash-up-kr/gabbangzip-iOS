//
//  ToastType.swift
//  DesignSystem
//
//  Created by GREEN on 6/29/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import SwiftUI

public enum ToastType {
  case onlyText(String)
  case textWithCheckIcon(String)
  case textWithInfoIcon(String)
  case textWithIcon(String, Image)
}
