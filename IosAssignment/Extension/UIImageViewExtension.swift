//
//  UIImageViewExtension.swift
//  IosAssignment
//
//  Created by Kerlos on 10/05/2025.
//

import Foundation
import UIKit

extension UIImageView {
    func loadImage(from urlString: String?, placeholder: UIImage? = nil) {
        self.image = placeholder
        
        guard let urlString = urlString, let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data, let image = UIImage(data: data), error == nil {
                DispatchQueue.main.async {
                    self.image = image
                }
            }
        }.resume()
    }
}
