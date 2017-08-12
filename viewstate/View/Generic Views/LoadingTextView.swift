//
//  LoadingTextView.swift
//  viewstate
//
//  Created by Christopher Trott on 8/12/17.
//  Copyright © 2017 twocentstudios. All rights reserved.
//

import UIKit
import QuartzCore

final class LoadingTextView: UIView {
    
    private let label: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.numberOfLines = 1
        return view
    }()
    
    private let background: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Color.gray20
        return view
    }()
    
    private let loadingAnimation: CAAnimation = {
        let animation = CABasicAnimation(keyPath: #keyPath(CALayer.backgroundColor))
        animation.fromValue = Color.gray20.cgColor
        animation.toValue = Color.gray45.cgColor
        animation.repeatCount = .infinity
        animation.autoreverses = true
        animation.duration = 0.8
        animation.timingFunction = CAMediaTimingFunction(controlPoints: 0.4, 0, 0.6, 1)
        return animation
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(background)
        addSubview(label)
        
        NSLayoutConstraint.activate([
            background.topAnchor.constraint(equalTo: topAnchor),
            background.bottomAnchor.constraint(equalTo: bottomAnchor),
            background.leadingAnchor.constraint(equalTo: leadingAnchor),
            background.trailingAnchor.constraint(equalTo: trailingAnchor),
            background.heightAnchor.constraint(greaterThanOrEqualToConstant: 22),
            
            label.topAnchor.constraint(equalTo: topAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor),
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor),
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with viewModel: LoadingTextViewModel) {
        label.isHidden = viewModel.isLoading
        label.attributedText = viewModel.text
        background.isHidden = !viewModel.isLoading
        animate(viewModel.isLoading)
    }
    
    private func animate(_ animate: Bool) {
        let key = "key"
        let isAnimating = background.layer.animation(forKey: key) != nil
        switch (animate, isAnimating) {
        case (true, false):
            background.layer.add(loadingAnimation, forKey: key)
        case (false, true):
            background.layer.removeAnimation(forKey: key)
        case (true, true),
             (false, false):
            break
        }
    }
}

