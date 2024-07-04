//
//  UIScreen+Extensions.swift
//  Common
//
//  Created by 최혜린 on 7/4/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import UIKit

// TODO: UIScreen 사용하지 않는 방향으로 개선 예정
public extension UIScreen {
    static var topSafeArea: CGFloat {
        let keyWindow = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?.windows
            .filter({$0.isKeyWindow}).first
        
        return (keyWindow?.safeAreaInsets.top) ?? 0
    }
  
  static var bottomSafeArea: CGFloat {
      let keyWindow = UIApplication.shared.connectedScenes
          .filter({$0.activationState == .foregroundActive})
          .map({$0 as? UIWindowScene})
          .compactMap({$0})
          .first?.windows
          .filter({$0.isKeyWindow}).first
      
      return (keyWindow?.safeAreaInsets.bottom) ?? 0
  }
}
