import Foundation

class WishlistManager: ObservableObject {
    @Published var wishlistItems: [WishlistItem] = []
    @Published var showTargetHitCard: Bool = false
    @Published var hitTargets: [WishlistItem] = []

    init() {
        loadWishlist()
    }

    func loadWishlist() {
        wishlistItems = LocalStorage.shared.load()
        checkHitTargets()
    }

    func saveWishlist() {
        LocalStorage.shared.save(wishlistItems)
    }

    func addItem(_ item: WishlistItem) {
        wishlistItems.append(item)
        saveWishlist()
        checkHitTargets()
    }

    func removeItem(_ item: WishlistItem) {
        if let index = wishlistItems.firstIndex(where: { $0.id == item.id }) {
            wishlistItems.remove(at: index)
            saveWishlist()
            checkHitTargets()
        }
    }

    func checkHitTargets() {
        hitTargets = wishlistItems.filter { $0.currentPrice <= $0.targetPrice }
        showTargetHitCard = !hitTargets.isEmpty
    }
}
