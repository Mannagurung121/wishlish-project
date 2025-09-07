//
//  GlobalModel.swift
//  wishCart
//
//  Created by Manan Gurung on 10/08/25.
//

import Foundation
import Combine

class WishlistViewModel: ObservableObject {
    @Published var items: [WishlistItem] = []
    
    // Jo items target hit kar chuke hain
    var hitTargets: [WishlistItem] {
        items.filter { $0.currentPrice <= $0.targetPrice }
    }
    
    // Jo abhi target tak nahi pahuche
    var pendingItems: [WishlistItem] {
        items.filter { $0.currentPrice > $0.targetPrice }
    }
    
    // Item delete karna ho to
    func removeItem(_ item: WishlistItem) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items.remove(at: index)
        }
    }
}
