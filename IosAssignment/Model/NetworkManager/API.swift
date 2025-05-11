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
        case product
        case productPagination(limit: Int, skip:Int)

        var urlString: String {
            switch self {
            case .product:
                return "\(API.baseURL)/products?"
            case .productPagination(let limit, let skip):
                return "\(API.baseURL)/products?limit=\(limit)&skip=\(skip)"
            }
        }
        var method: HTTPMethod {
            switch self {
            case .product, .productPagination:
                return .get
            }
        }
    }
}

enum ErrorMessage: String, Error {
    case invalidData = "Sorry, something went wrong. Try again."
    case invalidRequest = "Sorry, this URL isn't good enough. Try again later."
    case invalidResponse = "Server error. Modify your search and try again."
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

