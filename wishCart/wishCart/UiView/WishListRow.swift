//
//  WishListRow.swift
//  wishCart
//
//  Created by Manan Gurung on 07/08/25.
//

//
//  WishlistRowView.swift
//  wishCart
//
//  Created by Manan Gurung on 07/08/25.
//

import SwiftUI

struct WishlistRowView: View {
    let item: WishlistItem
    var onDelete: (() -> Void)? = nil

    var body: some View {
        ZStack(alignment: .topTrailing) {
            HStack(spacing: 16) {
                AsyncImage(url: URL(string: item.imageURL)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Color.gray.opacity(0.1)
                }
                .frame(width: 60, height: 60)
                .clipShape(RoundedRectangle(cornerRadius: 12))

                VStack(alignment: .leading, spacing: 6) {
                    Text(item.title)
                        .font(.system(.headline, design: .rounded))
                        .foregroundColor(.primary) // Adapts to dark/light mode
                        .lineLimit(2)

                    HStack(spacing: 8) {
                        Label("₹\(Int(item.currentPrice))", systemImage: "tag")
                            .font(.subheadline)
                            .foregroundColor(.secondary)

                        Spacer()

                        Label("₹\(Int(item.targetPrice))", systemImage: "bell.fill")
                            .font(.subheadline)
                            .foregroundColor(.mint)
                    }
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(Color(uiColor: .secondarySystemBackground)) // Dynamic for dark/light
                    .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
            )
            .padding(.horizontal)

            //  Remove Button
            if let onDelete = onDelete {
                Button(action: onDelete) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title3)
                        .foregroundColor(.mint)
                        .background(Color(uiColor: .systemBackground).clipShape(Circle()))
                        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
                }
                .offset(x: -10, y: -10)
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    WishlistRowView(
        item: WishlistItem(
            title: "Apple iPhone 14 (128GB, Blue)",
            currentPrice: 69990,
            targetPrice: 64999,
            imageURL: "https://via.placeholder.com/100"
        ),
        onDelete: {
            print("🗑️ Delete tapped")
        }
    )
    .background(Color(uiColor: .systemGroupedBackground))
    .preferredColorScheme(.dark) // Toggle to .light for testing both
}
