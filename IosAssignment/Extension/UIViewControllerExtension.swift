//
//  UIViewControllerExtension.swift
//  IosAssignment
//
//  Created by Kerlos on 10/05/2025.
//

import Foundation
import UIKit

extension UIViewController {
    func showAlert(title: String, message: String, actionTitle: String = "OK", completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: actionTitle, style: .default) { _ in
            completion?()
        })
        
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
}
