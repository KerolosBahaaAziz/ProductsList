//
//  ViewController.swift
//  IosAssignment
//
//  Created by Kerlos on 10/05/2025.
//

import UIKit

class ProductsViewController: UIViewController {

    var repo = ProductsRepository()
    
    enum LayoutType {
        case list, grid
    }

    var layoutType: LayoutType = .list {
        didSet {
            collectionView.setCollectionViewLayout(createLayout(), animated: true)
            for indexPath in collectionView.indexPathsForVisibleItems {
                collectionView.reloadItems(at: [indexPath])
            }
        }
    }

    var products: [Products] = []
    
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
        ///button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        //button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.layer.cornerRadius = 8
        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
        button.addTarget(self, action: #selector(toggleLayout), for: .touchUpInside)
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
        getProducts()
        
    }

    @objc func toggleLayout() {
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
        // detailsVC.product = selectedProduct  // Pass the selected product data
         present(detailsVC, animated: true)
    }
}

extension ProductsViewController{
    func getProducts(){
        repo.getProducts(limit: 7) { products, error in
            if error == nil{
                self.products = products ?? []
                print(products?[4].title)
                DispatchQueue.main.async{
                    self.collectionView.reloadData()
                }
            }else{
                print("Error is: \(error?.rawValue)")
            }
        }
    }
}

