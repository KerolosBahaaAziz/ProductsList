//
//  ProductDetailsViewController.swift
//  IosAssignment
//
//  Created by Kerlos on 10/05/2025.
//

import UIKit

class ProductDetailsViewController: UIViewController, UIScrollViewDelegate {

    var product: Products? 

    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private var ratingStack: UIStackView!

    private let headerImageView = UIImageView()
    private var headerHeightConstraint: NSLayoutConstraint!
    
    private let categoryLabel = UILabel()
    private let priceLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let ratingLabel = UILabel()

    private let headerHeight: CGFloat = 250

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        setupViews()
        setupConstraints()
        populateData()
    }

    private func setupViews() {
        scrollView.delegate = self
        scrollView.alwaysBounceVertical = true

        headerImageView.contentMode = .scaleAspectFit
        headerImageView.clipsToBounds = true

        [categoryLabel, priceLabel, descriptionLabel, ratingLabel].forEach {
            $0.font = UIFont.systemFont(ofSize: 16)
            $0.numberOfLines = 0
        }

        descriptionLabel.font = UIFont.systemFont(ofSize: 17)
        descriptionLabel.textColor = .darkGray

        priceLabel.font = UIFont.systemFont(ofSize: 19)
        categoryLabel.font = UIFont.systemFont(ofSize: 19)
        
        view.addSubview(scrollView)
        scrollView.addSubview(headerImageView)
        scrollView.addSubview(contentView)

        [categoryLabel, priceLabel, descriptionLabel, ratingLabel].forEach {
            contentView.addSubview($0)
        }

        let ratingStack = UIStackView()
        ratingStack.axis = .horizontal
        ratingStack.spacing = 4
        ratingStack.alignment = .leading

        self.ratingStack = ratingStack
        contentView.addSubview(ratingStack)
        ratingStack.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        headerImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        ratingLabel.translatesAutoresizingMaskIntoConstraints = false
    }

    private func setupConstraints() {
        headerHeightConstraint = headerImageView.heightAnchor.constraint(equalToConstant: headerHeight)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            headerImageView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 30),
            headerImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerHeightConstraint,

            contentView.topAnchor.constraint(equalTo: headerImageView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])

        // Layout content labels
        NSLayoutConstraint.activate([
            categoryLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            categoryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            categoryLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            priceLabel.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 12),
            priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            priceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            descriptionLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 12),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            ratingStack.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 12),
            ratingStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            ratingStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30)

        ])
    }

    private func populateData() {
        guard let product = product else { return }

        headerImageView.loadImage(from: product.image)

        categoryLabel.text = "Category: \(product.category ?? "-")"
        priceLabel.text = "Price: $\(product.price ?? 0)"
        descriptionLabel.text = "Description:\n\(product.description ?? "-")"
        if let rating = product.rating?.rate {
            setRatingStars(rating)
        }
    }

    private func setRatingStars(_ rating: Double) {
        // Remove previous stars
        ratingStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        let fullStars = Int(rating)
        let hasHalfStar = rating - Double(fullStars) >= 0.25 && rating - Double(fullStars) < 0.75
        let totalStars = hasHalfStar ? fullStars + 1 : fullStars
        let remaining = 5 - totalStars
        
        for _ in 0..<fullStars {
            ratingStack.addArrangedSubview(makeStarImage(name: "star.fill"))
        }
        if hasHalfStar {
            ratingStack.addArrangedSubview(makeStarImage(name: "star.lefthalf.fill"))
        }
        for _ in 0..<remaining {
            ratingStack.addArrangedSubview(makeStarImage(name: "star"))
        }
    }

    private func makeStarImage(name: String) -> UIImageView {
        let config = UIImage.SymbolConfiguration(pointSize: 18, weight: .regular)
        let imageView = UIImageView(image: UIImage(systemName: name, withConfiguration: config))
        imageView.tintColor = .systemYellow
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        return imageView
    }

    // MARK: - Stretch Header Logic
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        if offsetY < 0 {
            headerHeightConstraint.constant = headerHeight - offsetY
        } else {
            headerHeightConstraint.constant = headerHeight
        }
    }
    
}

