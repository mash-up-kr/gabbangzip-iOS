//
//  ActivityView.swift
//  Common
//
//  Created by GREEN on 6/5/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import SwiftUI

#if os(iOS)
public struct ActivityView: UIViewControllerRepresentable {
  @Binding var isPresented: Bool
  public let activityItems: [Any]
  public let applicationActivities: [UIActivity]? = nil
  public var completion: (() -> Void)?
  
  public init(
    isPresented: Binding<Bool>,
    activityItems: [Any],
    completion: (() -> Void)? = nil
  ) {
    self._isPresented = isPresented
    self.activityItems = activityItems
    self.completion = completion
  }
  
  public func makeUIViewController(context: Context) -> UIViewController {
    UIViewController()
  }
  
  public func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
    if isPresented && uiViewController.presentedViewController == nil {
      let activityViewController = UIActivityViewController(
        activityItems: activityItems,
        applicationActivities: applicationActivities
      )
      
      // iPad 대응 (추후 불필요 시 제거 가능)
      if let popoverPresentationController = activityViewController.popoverPresentationController {
        popoverPresentationController.sourceView = uiViewController.view
        popoverPresentationController.sourceRect = CGRect(
          x: uiViewController.view.bounds.midX,
          y: uiViewController.view.bounds.midY,
          width: 0,
          height: 0
        )
        popoverPresentationController.permittedArrowDirections = []
      }
      
      activityViewController.completionWithItemsHandler = { _, _, _, _ in
        isPresented = false
        completion?()
      }
      
      uiViewController.present(activityViewController, animated: true)
    }
  }
}
#endif
