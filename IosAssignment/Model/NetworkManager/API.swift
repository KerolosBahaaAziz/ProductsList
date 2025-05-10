//
//  API.swift
//  IosAssignment
//
//  Created by Kerlos on 10/05/2025.
//

import Foundation
enum API {
    static let baseURL = "https://fakestoreapi.com"
    
    enum Endpoint {
        case product(limit: Int)
        case productDetails(id: Int)

        var urlString: String {
            switch self {
            case .product(let limit):
                return "\(API.baseURL)/products?limit=\(limit)"
            case .productDetails(let id):
                return "\(API.baseURL)/products/\(id)"
            }
        }
    }
}

enum ErrorMessage: String, Error {
    case invalidData = "Sorry, something went wrong. Try again."
    case invalidRequest = "Sorry, this URL isn't good enough. Try again later."
    case invalidResponse = "Server error. Modify your search and try again."
}

