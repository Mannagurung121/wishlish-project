//
//  FireStore.swift
//  wishCart
//
//  Created by Manan Gurung on 07/08/25.
//

import FirebaseFirestore


class FirestoreService: ObservableObject {
    private let db = Firestore.firestore()
    private let collection = "wishlist"

    // Add or update wishlist item
    func addWishlistItem(_ item: WishlistItem) {
        do {
            try db.collection(collection).document(item.id).setData(from: item)
            print(" Item added/updated successfully")
        } catch {
            print(" Error adding/updating item: \(error.localizedDescription)")
        }
    }

    // Delete wishlist item
    func deleteWishlistItem(_ item: WishlistItem) {
        db.collection(collection).document(item.id).delete { error in
            if let error = error {
                print(" Error deleting item: \(error.localizedDescription)")
            } else {
                print("Item deleted successfully")
            }
        }
    }

    // Listen to real-time updates
    func listenToWishlistUpdates(completion: @escaping ([WishlistItem]) -> Void) {
        db.collection(collection).addSnapshotListener { snapshot, error in
            guard let documents = snapshot?.documents else {
                print(" Error fetching documents: \(error?.localizedDescription ?? "Unknown error")")
                completion([])
                return
            }
            let items = documents.compactMap { try? $0.data(as: WishlistItem.self) }
            completion(items)
        }
    }

    // Update targetHit flag
    func updateTargetHit(_ id: String?, _ value: Bool) {
        guard let docId = id else {
            print(" updateTargetHit failed: id is nil")
            return
        }
        db.collection(collection).document(docId).updateData(["targetHit": value]) { error in
            if let error = error {
                print(" Error updating targetHit: \(error.localizedDescription)")
            } else {
                print("targetHit updated successfully for id: \(docId)")
            }
        }
    }
}
