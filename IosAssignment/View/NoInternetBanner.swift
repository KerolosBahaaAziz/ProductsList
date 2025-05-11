//
//  NoInternetBanner.swift
//  IosAssignment
//
//  Created by Kerlos on 11/05/2025.
//

import Foundation
import Lottie
import UIKit

class NoInternetBanner: UIView {
    private let animationView: LottieAnimationView = {
        let animation = LottieAnimationView(name: "NoInternetAnimation")  // Add your Lottie JSON file here
        animation.contentMode = .scaleAspectFill
        animation.loopMode = .loop
        animation.play()
        return animation
    }()
    
    private let retryButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Retry", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        //button.addTarget(self, action: #selector(retryTapped), for: .touchUpInside)
        return button
    }()
    
    var retryAction: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        layer.zPosition = 999
        layer.cornerRadius = 8
        layer.masksToBounds = true
        retryButton.backgroundColor = .red
        isUserInteractionEnabled = true

        addSubview(animationView)
        addSubview(retryButton)

        retryButton.addTarget(self, action: #selector(retryTapped), for: .touchUpInside)
        animationView.translatesAutoresizingMaskIntoConstraints = false
        retryButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            // Center animation horizontally and vertically
            animationView.centerXAnchor.constraint(equalTo: centerXAnchor),
            animationView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0), // Adjust vertical position
            
            // Set animation size
            animationView.widthAnchor.constraint(equalToConstant: 250),  // Adjust size as needed
            animationView.heightAnchor.constraint(equalToConstant: 250),
            
            // Retry button below animation, centered horizontally
            retryButton.topAnchor.constraint(equalTo: animationView.bottomAnchor, constant: 16),
            retryButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            retryButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -56)
        ])
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        print("Retry button frame:", retryButton.frame) // Check if it has a valid size
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func retryTapped() {
        print("retry tapped")
        retryAction?()
    }
    
}
