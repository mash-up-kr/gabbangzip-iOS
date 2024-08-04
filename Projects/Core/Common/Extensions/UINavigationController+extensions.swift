//
//  UINavigationController+extensions.swift
//  Common
//
//  Created by YangJoonHyeok on 8/4/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import UIKit

extension UINavigationController: UIGestureRecognizerDelegate {
  override public func viewDidLoad() {
    super.viewDidLoad()
    interactivePopGestureRecognizer?.delegate = self
  }
  
  public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
    return viewControllers.count > 1
  }
}
