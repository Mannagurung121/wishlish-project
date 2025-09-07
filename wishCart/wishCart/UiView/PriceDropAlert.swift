//
//  PriceDropAlert.swift
//  wishCart
//
//  Created by Manan Gurung on 06/08/25.
//

//
//  PriceDropAlert.swift
//  wishCart
//
//  Created by Manan Gurung on 06/08/25.
//

import SwiftUI

struct PriceDropAlert: View {
    var product: WishlistItem
    var onClose: () -> Void
    
    @State private var showDetails = false
    @State private var isVisible = true
    @Namespace private var animation
    
    // Target price logic fix
    private var targetHit: Bool {
        product.currentPrice <= product.targetPrice
    }
    
    var body: some View {
        if isVisible {
            VStack(spacing: 0) {
                if !showDetails {
//                      Animation 1
                    LottieView(filename: "congratulation")
                        .frame(height: 200)
                        .padding(.top, 24)
                        .transition(.asymmetric(
                            insertion: .scale.combined(with: .opacity),
                            removal: .opacity
                        ))
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
                                withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                                    showDetails = true
                                }
                            }
                        }
                } else {
                    VStack(spacing: 20) {
                        
                        //  Product Info
                        HStack(spacing: 16) {
                            AsyncImage(url: URL(string: product.imageURL)) { image in
                                image
                                    .resizable()
                                    .scaledToFill()
                            } placeholder: {
                                ProgressView()
                                    .tint(.mint)
                            }
                            .frame(width: 70, height: 70)
                            .background(Color.white.opacity(0.2))
                            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                            .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
                            
                            VStack(alignment: .leading, spacing: 6) {
                                Text(product.title)
                                    .font(.system(.headline, design: .rounded))
                                    .foregroundColor(.primary)
                                    .lineLimit(2)
                                    .matchedGeometryEffect(id: "title", in: animation)
                                
                                if targetHit {
                                    VStack(alignment: .leading, spacing: 4) {
                                        HStack(spacing: 8) {
                                            Text("₹\(Int(product.targetPrice))")
                                                .foregroundColor(.secondary)
                                                .strikethrough(true, color: .red)
                                            
                                            Text("₹\(Int(product.currentPrice))")
                                                .font(.headline)
                                                .foregroundStyle(
                                                    LinearGradient(colors: [.green, .mint],
                                                                   startPoint: .leading,
                                                                   endPoint: .trailing)
                                                )
                                                .shadow(color: .green.opacity(0.5), radius: 5)
                                        }
                                        
                                        //  Price drop message
                                        Text("✨ Your target is here — time to grab it 🛒")
                                            .font(.subheadline)
                                            .foregroundStyle(.secondary)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .fixedSize(horizontal: false, vertical: true)   // <--- add this
                                            .padding(.top, 2)
                                            .transition(.opacity.combined(with: .move(edge: .bottom)))
                                            .animation(.easeInOut.delay(0.15), value: targetHit)
                                    }
                                } else {
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("Current Price: ₹\(Int(product.currentPrice))")
                                            .font(.headline)
                                            .foregroundColor(.secondary)
                                        
                                        Text("🎯 Target: ₹\(Int(product.targetPrice))")
                                            .font(.subheadline.bold())
                                            .foregroundColor(.mint)
                                    }
                                }
                            }
                            
                            Spacer()
                        }
                        
                        Divider()
                            .padding(.vertical, 6)
                            .opacity(0.3)
                        
                        // Buy Now Button
                        let buyNowLabel = HStack {
                            Image(systemName: "cart.fill")
                                .font(.headline)
                            Text("Buy Now")
                                .font(.headline)
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        
                        Button(action: {
                            if let urlString = product.productURL,
                               let url = URL(string: urlString) {
                                UIApplication.shared.open(url)
                            }
                        }) {
                            buyNowLabel
                                .background(
                                    LinearGradient(colors: [.mint, .green.opacity(0.8)],
                                                   startPoint: .topLeading,
                                                   endPoint: .bottomTrailing)
                                )
                                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                                .shadow(color: .green.opacity(0.3), radius: 8, x: 0, y: 4)
                        }
                        .buttonStyle(.scaleOnPress)
                        
                        // ❌ Dismiss
                        Button(action: {
                            withAnimation(.spring()) {
                                isVisible = false
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                                onClose()
                            }
                        }) {
                            Text("Dismiss")
                                .foregroundColor(.gray)
                                .font(.subheadline)
                        }
                        .padding(.top, 2)
                    }
                    .padding(24)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
            .padding(.vertical, 32)
            .background(
                .ultraThinMaterial,
                in: RoundedRectangle(cornerRadius: 28, style: .continuous)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 28)
                    .strokeBorder(Color.white.opacity(0.2), lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.15), radius: 20, x: 0, y: 10)
            .padding(.horizontal, 20)
            .frame(maxWidth: 420)
            .animation(.easeInOut(duration: 0.35), value: showDetails)
            .transition(.move(edge: .bottom).combined(with: .opacity))
        }
    }
}

// MARK: - Button Press Effect
extension ButtonStyle where Self == ScaleOnPressButtonStyle {
    static var scaleOnPress: ScaleOnPressButtonStyle { ScaleOnPressButtonStyle() }
}

struct ScaleOnPressButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.96 : 1)
            .opacity(configuration.isPressed ? 0.9 : 1)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
    }
}

// MARK: - Preview
#Preview {
    PriceDropAlert(
        product: WishlistItem(
            title: "Apple iPhone 14 (128GB, Blue)",
            currentPrice: 68999,
            targetPrice: 69900,
            imageURL: "https://via.placeholder.com/100",
            productURL: "https://www.apple.com/in/shop/buy-iphone/iphone-14"
        ),
        onClose: { print("Dismiss tapped") }
    )
}
