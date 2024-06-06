//
//  LottieTestView.swift
//  
//
//  Created by YangJoonHyeok on 6/6/24.
//

import SwiftUI
import Lottie

public struct LottieTestView: UIViewRepresentable {
	private let named: String
	private let contentMode: UIView.ContentMode
	private let loopMode: LottieLoopMode
	private let isPlaying: Bool
	private let completion: LottieCompletionBlock?
	
	public init(
		named: String,
		contentMode: UIView.ContentMode = .scaleAspectFit,
		loopMode: LottieLoopMode = .loop,
		isPlaying: Bool = true,
		completion: LottieCompletionBlock? = nil
	) {
		self.named = named
		self.contentMode = contentMode
		self.loopMode = loopMode
		self.isPlaying = isPlaying
		self.completion = completion
	}
	
	public func makeUIView(context: Context) -> UIView {
		let view = UIView(frame: .zero)
		let animationView = LottieAnimationView()
		
		animationView.frame = view.bounds
		animationView.animation = LottieAnimation.named(named, bundle: .module)
		animationView.contentMode = contentMode
		animationView.loopMode = loopMode
		if isPlaying {
			animationView.play(completion: completion)
		}
		
		animationView.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(animationView)
		
		NSLayoutConstraint.activate([
			animationView.widthAnchor.constraint(equalTo: view.widthAnchor),
			animationView.heightAnchor.constraint(equalTo: view.heightAnchor)
		])
		
		return view
	}
	
	public func updateUIView(_ uiView: UIView, context: Context) {
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

