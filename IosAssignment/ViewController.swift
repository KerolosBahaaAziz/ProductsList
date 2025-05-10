//
//  ViewController.swift
//  IosAssignment
//
//  Created by Kerlos on 10/05/2025.
//

import UIKit

class ViewController: UIViewController {

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

    lazy var toggleButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Switch to Grid", for: .normal)
        button.addTarget(self, action: #selector(toggleLayout), for: .touchUpInside)
        return button
    }()

    lazy var collectionView: UICollectionView = {
        let layout = createLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ProductCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.dataSource = self
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        view.addSubview(toggleButton)
        view.addSubview(collectionView)

        toggleButton.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            toggleButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            toggleButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            collectionView.topAnchor.constraint(equalTo: toggleButton.bottomAnchor, constant: 10),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
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

    @objc func toggleLayout() {
        layoutType = layoutType == .list ? .grid : .list
        let newTitle = layoutType == .list ? "Switch to Grid" : "Switch to List"
        toggleButton.setTitle(newTitle, for: .normal)
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

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let product = products[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ProductCell
        cell.configure(with: product, layout: layoutType)
        return cell
    }
}



