//
//  ConnectionBanner.swift
//  IosAssignment
//
//  Created by Kerlos on 11/05/2025.
//

import Foundation
import UIKit

class ConnectionBanner: UIView {
    private let label: UILabel = {
        let label = UILabel()
        label.text = "No Internet Connection"
        label.textAlignment = .center
        label.textColor = .white
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.systemRed
        layer.zPosition = 999
        layer.cornerRadius = 10
        layer.masksToBounds = true

        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            label.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
