//
//  Card.swift
//  wishCart
//
//  Created by Manan Gurung on 05/08/25.
//

import SwiftUI
import Lottie

struct ProductCardView: View {
    var onAdd: ((WishlistItem) -> Void)? = nil
    @State private var productLink = ""
    @State private var selectedSource = ""
    @State private var fetchedProduct: Product? = nil
    @State private var targetPrice: String = ""
    @State private var isExpanded = false
    @State private var showDropdown = false
    @State private var showCongrats = false
    @State private var showError = false
    @State private var showSourceError = false
    @State private var isFetching = false

    let sources = [
        Source(name: "Amazon", image: "amazon"),
        Source(name: "Flipkart", image: "flipkart")
    ]

    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack(spacing: 20) {
                // 🏷 Cute Header
                if !isExpanded {
                    Text("✨ Paste your magical link here…")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                        .padding(.top, 8)

                    LottieView(filename: "Shopping")
                        .frame(height: 140)
                        .padding(.bottom, 4)
                        .transition(.opacity)
                }

                // Link + Source Picker
                if !isExpanded {
                    VStack(alignment: .leading, spacing: 10) {
                        HStack(spacing: 12) {
                            TextField("Paste product link", text: $productLink)
                                .padding(12)
                                .background(Color(uiColor: .secondarySystemBackground))
                                .cornerRadius(12)
                                .shadow(color: Color.primary.opacity(0.05), radius: 4, x: 0, y: 2)
                                .foregroundColor(.primary)

                            Button(action: {
                                showDropdown.toggle()
                            }) {
                                if let selected = sources.first(where: { $0.name == selectedSource }) {
                                    GifView(gifName: selected.image)
                                        .frame(width: 40, height: 30)
                                        .clipShape(RoundedRectangle(cornerRadius: 6))
                                        .shadow(radius: 2)
                                } else {
                                    Image(systemName: "chevron.down")
                                        .padding(10)
                                        .background(Color.gray.opacity(0.2))
                                        .clipShape(Circle())
                                        .foregroundColor(.primary)
                                }
                            }
                        }

                        if showSourceError {
                            Text("❌ Please select a source")
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                    }

                    // Dropdown for sources
                    if showDropdown {
                        VStack(spacing: 8) {
                            ForEach(sources) { source in
                                Button {
                                    selectedSource = source.name
                                    showDropdown = false
                                    showSourceError = false
                                } label: {
                                    HStack(spacing: 10) {
                                        GifView(gifName: source.image)
                                            .frame(width: 40, height: 30)
                                            .clipShape(RoundedRectangle(cornerRadius: 6))
                                        Text(source.name)
                                            .foregroundColor(.primary)
                                    }
                                    .padding(.horizontal)
                                }
                            }
                        }
                        .padding(10)
                        .background(Color(uiColor: .secondarySystemBackground))
                        .cornerRadius(10)
                        .shadow(radius: 4)
                        .transition(.opacity)
                    }

                    // Fetch button
                    Button {
                        if selectedSource.isEmpty {
                            showSourceError = true
                            return
                        }
                        isFetching = true
                        fetchProductDetails(link: productLink) { product in
                            DispatchQueue.main.async {
                                isFetching = false
                                if let product = product {
                                    self.fetchedProduct = product
                                    withAnimation(.spring()) {
                                        self.isExpanded = true
                                        self.showCongrats = true
                                    }
                                } else {
                                    self.showError = true
                                }
                            }
                        }
                    } label: {
                        if isFetching {
                            ProgressView()
                                .frame(maxWidth: .infinity, minHeight: 48)
                        } else {
                            Text("Fetch Product Details")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 48)
                                .background(Color.mint)
                                .cornerRadius(12)
                        }
                    }
                    .padding(.top, 6)
                }

                // Expanded view after fetching
                if isExpanded, let product = fetchedProduct {
                    ZStack(alignment: .topLeading) {
                        if showCongrats {
                            LottieView(filename: "congratulation")
                                .opacity(0.15)
                                .scaleEffect(1.2)
                                .frame(height: 200)
                                .offset(y: -10)
                        }

                        VStack(spacing: 14) {
                            HStack(alignment: .top, spacing: 12) {
                                AsyncImage(url: URL(string: product.image)) { image in
                                    image.resizable()
                                } placeholder: {
                                    Color.gray.opacity(0.2)
                                }
                                .frame(width: 80, height: 80)
                                .cornerRadius(10)

                                VStack(alignment: .leading, spacing: 6) {
                                    Text(product.title)
                                        .font(.headline)
                                        .foregroundColor(.primary)

                                    Text("Current Price: ₹\(product.price)")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                                Spacer()
                            }

                            TextField("Set your target price", text: $targetPrice)
                                .keyboardType(.numberPad)
                                .padding()
                                .background(Color(uiColor: .secondarySystemBackground))
                                .cornerRadius(10)
                                .shadow(color: Color.primary.opacity(0.05), radius: 4, x: 0, y: 2)
                                .foregroundColor(.primary)

                            if let current = fetchedProduct?.price,
                               let entered = Int(targetPrice),
                               entered < current {
                                Text("🎯 Target set to ₹\(entered)")
                                    .font(.subheadline)
                                    .foregroundColor(.mint)
                            }

                            if showError {
                                Text("❌ Please enter a valid price lower than current")
                                    .font(.caption)
                                    .foregroundColor(.red)
                            }

                            Button {
                                if let current = fetchedProduct?.price,
                                   let entered = Int(targetPrice),
                                   entered < current {

                                    let newItem = WishlistItem(
                                        title: product.title,
                                        currentPrice: Double(current),
                                        targetPrice: Double(entered),
                                        imageURL: product.image
                                    )

                                    onAdd?(newItem)
                                    showCongrats = true
                                    showError = false
                                } else {
                                    showError = true
                                }
                            } label: {
                                Text("Set Price Alert")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 48)
                                    .background(Color.mint)
                                    .cornerRadius(12)
                            }
                        }
                        .padding(.top)
                    }
                    .transition(.opacity.combined(with: .move(edge: .top)))
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(Color(uiColor: .systemBackground))
                    .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 4)
            )
            .padding()

            // Close button
            if isExpanded {
                Button(action: {
                    withAnimation {
                        isExpanded = false
                        productLink = ""
                        targetPrice = ""
                        fetchedProduct = nil
                        showCongrats = false
                        showError = false
                        showSourceError = false
                    }
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                        .font(.title2)
                        .padding(12)
                }
            }
        }
    }
}

#Preview {
    ProductCardView()
        .preferredColorScheme(.dark)
}
