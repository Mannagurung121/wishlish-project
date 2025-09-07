

//
//  Model.swift
//  wishCart
//
//  Created by Manan Gurung on 06/08/25.
//

import Foundation
import FirebaseFirestore

// Product used when scraping


//  Source options  Amazon flipkart
struct Source: Identifiable {
    let id = UUID()
    let name: String
    let image: String
}

// Firestore compatible Wishlist Item
struct WishlistItem: Identifiable, Codable {
    var id: String = UUID().uuidString
    var title: String
    var currentPrice: Double
    var targetPrice: Double
    var imageURL: String
    var productURL: String? = nil // Optional if you want to open Buy Now
    var timestamp: Date = Date()

    //Firestore-friendly
    var hasPriceDropped: Bool {
        return currentPrice <= targetPrice
    }

    //  Exclude from Firestore
    enum CodingKeys: String, CodingKey {
        case id, title, currentPrice, targetPrice, imageURL, productURL, timestamp
    }
}
