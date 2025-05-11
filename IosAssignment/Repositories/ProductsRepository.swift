//
//  ProductsRepository.swift
//  IosAssignment
//
//  Created by Kerlos on 10/05/2025.
//

import Foundation

class ProductsRepository{
    func getProducts(completion: @escaping ([Products]?, ErrorMessage?) -> Void){
        NetworkService.shared.fetchData(APICase: .product, DecodingModel: [Products].self) { results in
            switch results{
            case .success(let products):
                print("products elements = \(products.count)")
                completion(products, nil)
            case .failure(let error):
                print("error is : \(error.rawValue)")
                completion(nil, error)
            }
        }
    }
    
    func getProductsBagination(limit: Int, skip: Int, completion: @escaping ([Products]?, ErrorMessage?) -> Void) {
        NetworkService.shared.fetchData(APICase: .productPagination(limit: limit, skip: skip), DecodingModel: [Products].self) { results in
                switch results {
                case .success(let products):
                    print("Fetched \(products.count) products")
                    completion(products, nil)
                case .failure(let error):
                    print("Error: \(error.rawValue)")
                    completion(nil, error)
                }
            }
        }
}
