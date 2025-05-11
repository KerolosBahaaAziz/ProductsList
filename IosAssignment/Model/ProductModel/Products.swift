//
//  Products.swift
//  IosAssignment
//
//  Created by Kerlos on 10/05/2025.
//

import Foundation

struct Products: Codable, Identifiable {
    let id: Int?
    let title: String?
    let image: String?
    let price: Double?
    let description: String?
    let category: String?
    let rating: Rating?
}

struct Rating: Codable {
    let rate: Double?
    let count: Int?
}
