//
//  WishListModel.swift
//  wishCart
//
//  Created by Manan Gurung on 26/07/25.
//
import Foundation
class LocalStorage {
    static let shared = LocalStorage()
    private let key = "wishlistItems"

    func save(_ items: [WishlistItem]) {
        if let encoded = try? JSONEncoder().encode(items) {
            UserDefaults.standard.set(encoded, forKey: key)
        }
    }

    func load() -> [WishlistItem] {
        if let data = UserDefaults.standard.data(forKey: key),
           let decoded = try? JSONDecoder().decode([WishlistItem].self, from: data) {
            return decoded
        }
        return []
    }
}
