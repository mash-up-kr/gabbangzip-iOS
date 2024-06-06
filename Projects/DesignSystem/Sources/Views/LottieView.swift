//
//  LottieView.swift
//  DesignSystem
//
//  Created by GREEN on 6/6/24.
//  Copyright © 2024 com.mashup.gabbangzip. All rights reserved.
//

import Lottie
import SwiftUI

public struct LottieView: UIViewRepresentable {
  public typealias CompletionBlock = LottieCompletionBlock?
  private let type: GabbangzipLottieAnimationType
  private let loopMode: LottieLoopMode
  private let completion: CompletionBlock
  
  public init(
    type: GabbangzipLottieAnimationType,
    loopMode: LottieLoopMode = .loop,
    completion: CompletionBlock = { _ in }
  ) {
    self.type = type
    self.loopMode = loopMode
    self.completion = completion
  }
  
  public func makeUIView(context: Context) -> some UIView {
    let view = UIView(frame: .zero)
    let animationView = configureLottieAnimationView()
    
    view.addSubview(animationView)
    
    NSLayoutConstraint.activate([
      animationView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      animationView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      animationView.heightAnchor.constraint(equalTo: view.heightAnchor),
      animationView.widthAnchor.constraint(equalTo: view.widthAnchor)
    ])
    
    return view
  }
  
  public func updateUIView(_ uiView: UIViewType, context: Context) { }
  
  private func configureLottieAnimationView() -> LottieAnimationView {
    let animationView = LottieAnimationView()
    
    guard let path = DesignSystemResources.bundle.path(
      forResource: type.name,
      ofType: "json"
    ) else {
      return animationView
    }
    
    do {
      let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
      
      let animation = try LottieAnimation.from(data: data)
      animationView.animation = animation
      animationView.contentMode = .scaleAspectFit
      animationView.loopMode = self.loopMode
      animationView.play(completion: self.completion)
      animationView.backgroundBehavior = .pauseAndRestore
      animationView.translatesAutoresizingMaskIntoConstraints = false
    } catch {
      print("Error loading Lottie animation: \(error)")
    }
    
    return animationView
  }
}

// MARK: - 로티 애니메이션 종류
public enum GabbangzipLottieAnimationType {
  /// 임시 테스트용 로티 케이스로 추후 제거 필요
  case confetti
  case bookmark
  
  var fileName: String {
    switch self {
    case .confetti:
      return JSONFiles.Confetti.name
    case .bookmark:
      return JSONFiles.Bookmark.name
    }
  }
  
  var name: String {
    self.fileName.replacingOccurrences(of: ".json", with: "")
  }
}
