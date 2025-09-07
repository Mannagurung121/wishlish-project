import SwiftUI

struct AddDetailView: View {
    @ObservedObject var wishlistManager: WishlistManager
    @State private var showCard = false
    @State private var showPriceDropAlert = false
    @State private var droppedProduct: WishlistItem? = nil
    @Namespace private var animation

    let mintColor = Color(red: 223/255, green: 247/255, blue: 243/255) // #DFF7F3

    var body: some View {
        NavigationView {
            ZStack {
                Color(uiColor: .systemBackground)
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    HStack {
                        Text("Welcome Back!")
                            .font(.title2)
                            .foregroundColor(.primary)
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.top, 16)
                    .padding(.bottom, 8)

                    if wishlistManager.wishlistItems.isEmpty {
                        Spacer()
                        VStack(spacing: 12) {
                            LottieView(filename: "empty", loopMode: .loop)
                                .frame(width: 200, height: 200)

                            Text("No wishlist yet")
                                .font(.title3)
                                .fontWeight(.medium)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                    } else {
                        ScrollView {
                            VStack(spacing: 12) {
                                ForEach(wishlistManager.wishlistItems) { item in
                                    WishlistRowView(item: item) {
                                        withAnimation(.easeIn) {
                                            wishlistManager.removeItem(item)
                                        }
                                    }
                                    .matchedGeometryEffect(id: item.id, in: animation)
                                }
                            }
                            .padding(.top, 12)
                            .padding(.bottom, 100)
                        }
                    }
                }

                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            withAnimation(.spring()) {
                                showCard = true
                            }
                        }) {
                            Image(systemName: "plus")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.mint)
                                .padding()
                                .background(.ultraThinMaterial)
                                .clipShape(Circle())
                                .shadow(color: .mint.opacity(0.4), radius: 6, x: 0, y: 4)
                        }
                        .padding(.bottom, 30)
                        .padding(.trailing)
                    }
                }

                if showPriceDropAlert, let product = droppedProduct {
                    Color.black.opacity(0.25)
                        .ignoresSafeArea()
                        .transition(.opacity)

                    VStack {
                        PriceDropAlert(product: product) {
                            withAnimation {
                                showPriceDropAlert = false
                            }
                        }
                        .transition(.move(edge: .top).combined(with: .opacity))
                        Spacer()
                    }
                    .zIndex(1)
                }
            }
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $showCard) {
            ZStack {
                Color.black.opacity(0.25)
                    .ignoresSafeArea()

                VStack {
                    Spacer()
                    ProductCardView { newItem in
                        wishlistManager.addItem(newItem)
                        showCard = false

                        if newItem.currentPrice <= newItem.targetPrice {
                            droppedProduct = newItem
                            withAnimation {
                                showPriceDropAlert = true
                            }
                        }
                    }
                    .padding()
                    Spacer()
                }
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
    }
}

// MARK: - Preview

struct AddDetailView_Previews: PreviewProvider {
    static var wishlistManager: WishlistManager = {
        let manager = WishlistManager()
        manager.wishlistItems = [
            WishlistItem(
                title: "Sample Product",
                currentPrice: 1500,
                targetPrice: 1400,
                imageURL: "https://via.placeholder.com/150"
            )
        ]
        return manager
    }()

    static var previews: some View {
        AddDetailView(wishlistManager: wishlistManager)
    }
}
