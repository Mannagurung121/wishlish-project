import SwiftUI

struct TargetCompleted: View {
    @ObservedObject var wishlistManager: WishlistManager
    
    @Environment(\.openURL) var openURL
    
    private var hitTargets: [WishlistItem] {
        wishlistManager.wishlistItems.filter { $0.currentPrice <= $0.targetPrice }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Hit Targets 🎯")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding(.leading, 20)
                Spacer()
            }
            .padding(.top, 60)
            .padding(.bottom, 12)
            
            ScrollView {
                VStack(spacing: 24) {
                    if hitTargets.isEmpty {
                        VStack(spacing: 16) {
                            Image(systemName: "checkmark.seal")
                                .font(.system(size: 60))
                                .foregroundColor(.mint)
                            
                            Text("No targets hit yet 🎯")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundColor(.secondary)
                            
                            Text("Keep tracking your wishlist — deals are on the way!")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 30)
                        }
                        .padding(.top, 80)
                    } else {
                        ForEach(hitTargets, id: \.id) { product in
                            HStack(spacing: 20) {
                                AsyncImage(url: URL(string: product.imageURL)) { image in
                                    image
                                        .resizable()
                                        .scaledToFill()
                                } placeholder: {
                                    ProgressView()
                                        .tint(.mint)
                                }
                                .frame(width: 80, height: 80)
                                .background(Color(.systemGray6))
                                .clipShape(RoundedRectangle(cornerRadius: 14))
                                .shadow(color: .black.opacity(0.06), radius: 6, x: 0, y: 3)
                                .onTapGesture {
                                    if let urlString = product.productURL,
                                       let url = URL(string: urlString) {
                                        openURL(url)
                                    }
                                }
                                
                                VStack(alignment: .leading, spacing: 6) {
                                    Text(product.title)
                                        .font(.headline)
                                        .foregroundColor(.primary)
                                        .lineLimit(2)
                                    
                                    HStack(spacing: 12) {
                                        Text("₹\(Int(product.targetPrice))")
                                            .foregroundColor(.secondary)
                                            .strikethrough(true, color: .red)
                                        
                                        Text("₹\(Int(product.currentPrice))")
                                            .font(.headline)
                                            .foregroundColor(.green)
                                    }
                                }
                                Spacer()
                                
                                Button(action: {
                                    wishlistManager.removeItem(product)
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .font(.title2)
                                        .foregroundColor(.secondary)
                                }
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color(.systemBackground))
                                    .shadow(color: .black.opacity(0.07), radius: 8, x: 0, y: 4)
                            )
                            .padding(.horizontal, 20)
                        }
                        
                        Text("✨ Your target is here — time to grab it. 🛒")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.top, 16)
                            .padding(.horizontal, 30)
                    }
                }
                .padding(.bottom, 30)
            }
        }
        .ignoresSafeArea(.container, edges: .top)
    }
}

// MARK: - Preview with WishlistManager

struct TargetCompleted_Previews: PreviewProvider {
    static var wishlistManager: WishlistManager = {
        let manager = WishlistManager()
        manager.wishlistItems = [
            WishlistItem(
                title: "Apple iPhone 14 (128GB, Blue)",
                currentPrice: 68999,
                targetPrice: 69900,
                imageURL: "https://via.placeholder.com/100",
                productURL: "https://apple.com"
            ),
            WishlistItem(
                title: "Sony WH-1000XM5 Headphones",
                currentPrice: 24990,
                targetPrice: 24990,
                imageURL: "https://via.placeholder.com/100",
                productURL: "https://sony.com"
            ),
            WishlistItem(
                title: "MacBook Air M2",
                currentPrice: 109990,
                targetPrice: 105000,
                imageURL: "https://via.placeholder.com/100",
                productURL: "https://apple.com/macbook-air"
            )
        ]
        return manager
    }()
    
    static var previews: some View {
        TargetCompleted(wishlistManager: wishlistManager)
    }
}
