//
//  ProductCell.swift
//  IosAssignment
//
//  Created by Kerlos on 10/05/2025.
//

import Foundation
import UIKit
import SkeletonView

class ProductCell: UICollectionViewCell {
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    
    private var currentConstraints: [NSLayoutConstraint] = []

    override init(frame: CGRect) {
        super.init(frame: frame)

        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        titleLabel.numberOfLines = 2
        
        isSkeletonable = true
        contentView.isSkeletonable = true
        
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
        contentView.backgroundColor = .systemGray6
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with product: Products, layout: ProductsViewController.LayoutType) {
        titleLabel.text = product.title
        imageView.loadImage(from: product.image)
        applyLayout(layout)
    }

    private func applyLayout(_ layout: ProductsViewController.LayoutType) {
        
        NSLayoutConstraint.deactivate(currentConstraints)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        switch layout {
        case .grid:
            currentConstraints = [
                imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
                imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                imageView.heightAnchor.constraint(equalTo: contentView.widthAnchor),

                titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 5),
                titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
                titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
                titleLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor)
            ]

        case .list:
            currentConstraints = [
                imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
                imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                imageView.widthAnchor.constraint(equalToConstant: 80),
                imageView.heightAnchor.constraint(equalToConstant: 80),

                titleLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 12),
                titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
            ]
        }

        NSLayoutConstraint.activate(currentConstraints)
    }
}
