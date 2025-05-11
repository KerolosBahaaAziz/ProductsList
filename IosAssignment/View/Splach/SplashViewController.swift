//
//  SplashViewController.swift
//  IosAssignment
//
//  Created by Kerlos on 10/05/2025.
//

import UIKit
import Lottie

class SplashViewController: UIViewController {

    private var animationView: LottieAnimationView?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
        playSplashAnimation()
    }

    private func playSplashAnimation() {
        animationView = LottieAnimationView(name: "SplashAnimation")
        guard let animationView = animationView else { return }

        animationView.frame = view.bounds
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .playOnce

        view.addSubview(animationView)
        animationView.play { [weak self] _ in
            self?.navigateToMainScreen()
        }
    }

    private func navigateToMainScreen() {
        let mainVC = ProductsViewController()
        let navController = UINavigationController(rootViewController: mainVC)
        navController.modalPresentationStyle = .fullScreen
        self.present(navController, animated: true)
    }
}

