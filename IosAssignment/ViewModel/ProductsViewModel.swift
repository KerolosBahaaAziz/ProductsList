//
//  ProductsViewModel.swift
//  IosAssignment
//
//  Created by Kerlos on 11/05/2025.
//

import Foundation
import UIKit

extension ProductsViewController{
    func getProducts() {
        
        guard NetworkMonitor.shared.isConnected else {
           // self.showAlert(title: "No Connection", message: "Please check your internet connection")
            DispatchQueue.main.async{
                self.collectionView.showAnimatedGradientSkeleton()
            }
            return
        }
        didLoadData = true
        self.collectionView.showAnimatedGradientSkeleton()
        
        
        self.repo.getProducts() { products, error in
            DispatchQueue.main.async {
                self.collectionView.stopSkeletonAnimation()
                self.collectionView.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.25))
            }
            
            if let error = error {
                DispatchQueue.main.async {
                    self.showAlert(title: "Error", message: error.rawValue)
                }
            } else {
                self.products = products ?? []
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
            
        }
    }

    func observeNetworkStatus() {
        NetworkMonitor.shared.addObserver { [weak self] isConnected in
            guard let self = self else { return }

            if !isConnected {
                if self.banner == nil {
                    let banner = ConnectionBanner()
                    banner.translatesAutoresizingMaskIntoConstraints = false
                    self.view.addSubview(banner)

                    NSLayoutConstraint.activate([
                        banner.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 8),
                        banner.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
                        banner.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
                        banner.heightAnchor.constraint(equalToConstant: 44)
                    ])

                    banner.alpha = 0
                    UIView.animate(withDuration: 0.3) {
                        banner.alpha = 1
                    }

                    self.banner = banner
                }
            } else {
                if let banner = self.banner {
                    UIView.animate(withDuration: 0.3, animations: {
                        banner.alpha = 0
                    }) { _ in
                        banner.removeFromSuperview()
                        self.banner = nil
                    }
                }
            }
        }
    }

}

// MARK: - Code for Bagination
/*
extension ProductsViewController {

    func getProductsBagination(reset: Bool = false) {
        
        if reset {
            products.removeAll()
            currentSkip = 0
        }

        guard !isLoading else { return }
        isLoading = true

        if reset {
            collectionView.showAnimatedGradientSkeleton()
        }

        repo.getProductsBagination(limit: limit, skip: currentSkip) { [weak self] products, error in
            guard let self = self else { return }
            self.isLoading = false

            DispatchQueue.main.async {
                self.collectionView.stopSkeletonAnimation()
                self.collectionView.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.25))
            }

            if let products = products {
                self.products.append(contentsOf: products)
                self.currentSkip += self.limit

                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            } else if let error = error {
                print("Load error: \(error.rawValue)")
            }
        }
    }

    // Detect scroll to bottom
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height

        if offsetY > contentHeight - scrollView.frame.height - 100 {
            getProductsBagination()
        }
    }
}
*/
