//
//  Font+extensions.swift
//  DesignSystem
//
//  Created by GREEN on 2024/05/20.
//  Copyright © 2024 mashup.gabbangzip. All rights reserved.
//

import SwiftUI
import UIKit

public extension Font {
  init(uiFont: UIFont) {
    self = Font(uiFont as CTFont)
  }
}
