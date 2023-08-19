//
//  Product.swift
//  ShoppingDemo
//
//  Created by Qi Zhu on 8/13/23.
//

import Foundation

class ProductList: Codable {
    
}

class Product: Codable {
    var rating: Int
    var id: Int
    var price: Double
    var name: String
    var cover: String
    var images: [String]
}


