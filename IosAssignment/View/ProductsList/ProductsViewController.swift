//
//  ViewController.swift
//  IosAssignment
//
//  Created by Kerlos on 10/05/2025.
//

import UIKit
import SkeletonView
import Network

class ProductsViewController: UIViewController {

    var repo = ProductsRepository()
    var banner: ConnectionBanner?
    var products: [Products] = []
    var didLoadData = false
    
    //for pagiantion
    let limit = 7
    var currentSkip = 0
    var isLoading = false

    
    enum LayoutType {
        case list, grid
    }

    var layoutType: LayoutType = .list {
        didSet {
            collectionView.setCollectionViewLayout(createLayout(), animated: true)
            for indexPath in collectionView.indexPathsForVisibleItems {
                collectionView.reloadItems(at: [indexPath])
            }
            toggleLayout()
        }
    }

    private let titleLabel: UILabel = {
           let label = UILabel()
           label.text = "Products List"
           label.font = UIFont.boldSystemFont(ofSize: 24)
           label.textAlignment = .left
           return label
       }()

    lazy var toggleButton: UIButton = {
        let button = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .medium)
        let image = UIImage(systemName: "square.grid.2x2", withConfiguration: config)
        button.setImage(image, for: .normal)
        button.layer.cornerRadius = 8
        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
        button.addTarget(self, action: #selector(switchLayout), for: .touchUpInside)
        return button
    }()

    lazy var collectionView: UICollectionView = {
        let layout = createLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ProductCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.dataSource = self
        collectionView.delegate = self 
        return collectionView
    }()

   
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        observeNetworkStatus()
        getProducts()
        NotificationCenter.default.addObserver(self, selector: #selector(networkStatusChanged), name: .internetStatusChanged, object: nil)
        
    }
    
    @objc private func networkStatusChanged(notification: Notification) {
        guard NetworkMonitor.shared.isConnected, !didLoadData else { return }
        getProducts()
    }

    
    @objc func switchLayout() {
        layoutType = (layoutType == .list) ? .grid : .list
    }

    func toggleLayout() {
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .medium)
        let iconName = (layoutType == .list) ? "square.grid.2x2" : "list.bullet"
        let image = UIImage(systemName: iconName, withConfiguration: config)
        toggleButton.setImage(image, for: .normal)
    }

    func setupView(){
        view.backgroundColor = .white

        view.addSubview(toggleButton)
        view.addSubview(collectionView)
        view.addSubview(titleLabel)
        
        collectionView.isSkeletonable = true
        view.isSkeletonable = true

        toggleButton.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
                titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
                titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                
                toggleButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
                toggleButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

                collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
                collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
                collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
                collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
    }
    
    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        let spacing: CGFloat = 10
        let width = view.frame.width

        switch layoutType {
        case .list:
            layout.itemSize = CGSize(width: width - 2 * spacing, height: 100)
        case .grid:
            let itemWidth = (width - 3 * spacing) / 2
            layout.itemSize = CGSize(width: itemWidth, height: itemWidth + 60)
        }

        return layout
    }
}

// MARK: - UICollectionView Delegates
extension ProductsViewController: UICollectionViewDataSource, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let product = products[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ProductCell
        cell.configure(with: product, layout: layoutType)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedProduct = products[indexPath.item]
        print("selectedProduct \(indexPath.item)")
         let detailsVC = ProductDetailsViewController()
        detailsVC.product = selectedProduct  
        navigationController?.pushViewController(detailsVC, animated: true)
    }
}

extension ProductsViewController: SkeletonCollectionViewDataSource {
    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }

    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "Cell"
    }

}

