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
  private let contentMode: UIView.ContentMode
  private let backgroundBehavior: LottieBackgroundBehavior
  private var isPlaying: Bool
  private let completion: CompletionBlock
  
  public init(
    type: GabbangzipLottieAnimationType,
    loopMode: LottieLoopMode = .loop,
    contentMode: UIView.ContentMode = .scaleAspectFit,
    backgroundBehavior: LottieBackgroundBehavior = .pauseAndRestore,
    isPlaying: Bool = true,
    completion: CompletionBlock = { _ in }
  ) {
    self.type = type
    self.loopMode = loopMode
    self.contentMode = contentMode
    self.backgroundBehavior = backgroundBehavior
    self.isPlaying = isPlaying
    self.completion = completion
  }
  
  public func makeUIView(context: Context) -> some UIView {
    let view = UIView(frame: .zero)
    let animationView = LottieAnimationView()
    
    animationView.frame = view.bounds
    animationView.animation = LottieAnimation.named(type.fileName, bundle: .module)
    animationView.loopMode = self.loopMode
    animationView.contentMode = self.contentMode
    animationView.backgroundBehavior = self.backgroundBehavior
    if isPlaying {
      animationView.play(completion: self.completion)
    }
    animationView.translatesAutoresizingMaskIntoConstraints = false
    
    view.addSubview(animationView)
    
    NSLayoutConstraint.activate([
      animationView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      animationView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      animationView.heightAnchor.constraint(equalTo: view.heightAnchor),
      animationView.widthAnchor.constraint(equalTo: view.widthAnchor)
    ])
    
    return view
  }
  
  public func updateUIView(_ uiView: UIViewType, context: Context) {
    guard let animationView = uiView.subviews.first as? LottieAnimationView else {
      return
    }
    
    if isPlaying {
      if !animationView.isAnimationPlaying {
        animationView.play(completion: completion)
      }
    } else {
      if animationView.isAnimationPlaying {
        animationView.pause()
      }
    }
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
}
