//
//  HomePage.swift
//  wishCart
//
//  Created by Manan Gurung on 09/08/25.
//

import SwiftUI

struct HomePage: View {
    @StateObject private var wishlistManager = WishlistManager()
    @EnvironmentObject var authHandlers: FirebaseManager

    @State private var selectedIndex = 0
    @State private var animateIndex: Int? = nil
    let mintColor = Color(red: 223/255, green: 247/255, blue: 243/255) // #DFF7F3

    var body: some View {
        VStack(spacing: 0) {
            Group {
                switch selectedIndex {
                case 0:
                    AddDetailView(wishlistManager: wishlistManager)
                case 1:
                    TargetCompleted(wishlistManager: wishlistManager)
                case 2:
                    AccountDetail()
                default:
                    AddDetailView(wishlistManager: wishlistManager)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                selectedIndex == 0 ? mintColor : Color(uiColor: .systemBackground)
            )
            .ignoresSafeArea()

            HStack(spacing: 40) {
                tabBarItem(title: "WishList", systemImage: "giftcard.fill", index: 0)
                tabBarItem(title: "Targets", systemImage: "checkmark.seal.fill", index: 1)
                tabBarItem(title: "Account", systemImage: "person.crop.circle", index: 2)
            }
            .padding(.horizontal, 30)
            .padding(.vertical, 12)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
            .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: -3)
            .padding(.horizontal)
            .padding(.bottom, 12)
        }
        .animation(.spring(response: 0.35, dampingFraction: 0.75), value: selectedIndex)
    }

    @ViewBuilder
    private func tabBarItem(title: String, systemImage: String, index: Int) -> some View {
        Button {
            withAnimation(.easeInOut(duration: 0.3)) {
                selectedIndex = index
                animateIndex = index
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation {
                    animateIndex = nil
                }
            }
        } label: {
            VStack(spacing: 4) {
                Image(systemName: systemImage)
                    .font(.system(size: selectedIndex == index ? 26 : 22))
                    .foregroundColor(selectedIndex == index ? .mint : .gray)
                    .scaleEffect(animateIndex == index ? 1.3 : (selectedIndex == index ? 1.15 : 1))

                Text(title)
                    .font(.caption)
                    .fontWeight(selectedIndex == index ? .semibold : .regular)
                    .foregroundColor(selectedIndex == index ? .mint : .gray)
            }
            .padding(.vertical, 6)
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(PlainButtonStyle())
    }
}


struct HomePage_Previews: PreviewProvider {
    static var previews: some View {
        HomePage()
            .environmentObject(FirebaseManager.shared) //  Preview 
    }
}
