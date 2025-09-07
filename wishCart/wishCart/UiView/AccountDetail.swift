import SwiftUI
import FirebaseAuth

struct AccountDetail: View {
    @State private var navigateToAddDetail = false
    @State private var navigateToSaveDetail = false

    @State private var userName: String = "User Name"
    @State private var userEmail: String = "user@example.com"
    
    @Environment(\.colorScheme) var colorScheme

    var headerGradient: LinearGradient {
        if colorScheme == .dark {
            return LinearGradient(
                colors: [Color.mint.opacity(0.2), Color.mint.opacity(0.5)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        } else {
            return LinearGradient(
                colors: [
                    Color(red: 223/255, green: 247/255, blue: 243/255),
                    Color.mint.opacity(0.8)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemBackground) // Adaptive background
                    .ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {
                        
                        // Mint header
                        ZStack {
                            headerGradient
                                .frame(height: 160)
                                .clipShape(RoundedRectangle(cornerRadius: 30))
                                .padding(.horizontal)
                                .shadow(radius: 10)

                            VStack(spacing: 8) {
                                Text(userName)
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                    .foregroundColor(Color(.label)) // adaptive text color

                                Text(userEmail)
                                    .font(.subheadline)
                                    .foregroundColor(Color(.secondaryLabel))

                                Button {
                                    navigateToAddDetail = true
                                } label: {
                                    Text("Edit Profile")
                                        .font(.subheadline)
                                        .foregroundColor(.mint)
                                        .padding(.horizontal, 14)
                                        .padding(.vertical, 6)
                                        .background(Color(.systemBackground))
                                        .clipShape(Capsule())
                                        .shadow(radius: 3)
                                }
                                .padding(.top, 4)
                            }
                        }
                        .padding(.top)
                        .onAppear {
                            if let user = Auth.auth().currentUser {
                                userName = user.displayName ?? "No Name"
                                userEmail = user.email ?? "No Email"
                            }
                        }

                        // Action Buttons
                        VStack(spacing: 16) {
                            AccountButton(
                                icon: "person.crop.circle.badge.plus",
                                title: "Add Detail",
                                color: .blue
                            ) { navigateToAddDetail = true }

                            AccountButton(
                                icon: "widget.medium",
                                title: "Save Detail",
                                color: .green
                            ) { navigateToSaveDetail = true }

                            AccountButton(
                                icon: "arrow.backward.square.fill",
                                title: "Log Out",
                                color: .red
                            ) {
                                FirebaseManager.shared.signOut()
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 10)

                        Spacer(minLength: 50)
                    }
                }
            }
            .navigationTitle("")
            .navigationBarHidden(true)
            .navigationDestination(isPresented: $navigateToAddDetail) {
                UserDetail()
            }
            .navigationDestination(isPresented: $navigateToSaveDetail) {
                SaveData()
            }
        }
    }
}

struct AccountButton: View {
    var icon: String
    var title: String
    var color: Color
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(.white)
                    .frame(width: 44, height: 44)
                    .background(color)
                    .clipShape(RoundedRectangle(cornerRadius: 12))

                Text(title)
                    .font(.headline)
                    .foregroundColor(Color(.label))

                Spacer()
            }
            .padding()
            .background(Color(.secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 3)
        }
    }
}

struct AccountDetail_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AccountDetail()
                .preferredColorScheme(.light)
            AccountDetail()
                .preferredColorScheme(.dark)
        }
    }
}
