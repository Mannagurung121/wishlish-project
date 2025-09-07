import SwiftUI
import UIKit

struct LoginView: View {
    @EnvironmentObject var authHandlers: FirebaseManager
    @State private var email = ""
    @State private var password = ""
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        NavigationView {
            ZStack {
                // Background gradient with subtle circles
                LinearGradient(
                    colors: [Color.white, Color(UIColor.systemMint).opacity(0.3)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

        
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.12))
                        .frame(width: 180, height: 180)
                        .blur(radius: 55)
                        .offset(x: -90, y: -140)

                    Circle()
                        .fill(Color.white.opacity(0.08))
                        .frame(width: 140, height: 140)
                        .blur(radius: 40)
                        .offset(x: 110, y: -70)

                    Circle()
                        .fill(Color.white.opacity(0.10))
                        .frame(width: 200, height: 200)
                        .blur(radius: 65)
                        .offset(x: 90, y: 160)
                }
                .ignoresSafeArea()

                VStack(spacing: 12) {
                    Spacer(minLength: 30)

                    // Lottie animation
                    LottieView(filename: "Welcome")
                        .frame(width: 120, height: 120)

                    // Subtitle text
                    Text("Sign in to your account")
                        .font(.title3.weight(.medium))
                        .foregroundColor(.secondary)
                        .padding(.bottom, 20)

                    VStack(spacing: 12) {
                        // Email field
                        TextField("Email Address", text: $email)
                            .keyboardType(.emailAddress)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                            .padding(14)
                            .background(Color(UIColor.secondarySystemBackground))
                            .cornerRadius(10)
                            .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.3 : 0.1),
                                    radius: 3, x: 0, y: 1)

                        // Password field
                        SecureField("Password", text: $password)
                            .padding(14)
                            .background(Color(UIColor.secondarySystemBackground))
                            .cornerRadius(10)
                            .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.3 : 0.1),
                                    radius: 3, x: 0, y: 1)
                    }
                    .frame(maxWidth: 360)

                    // Sign In Button
                    Button(action: {
                        authHandlers.signInWithEmail(email: email, password: password) { _ in }
                    }) {
                        if authHandlers.isLoading {
                            ProgressView()
                                .frame(maxWidth: .infinity)
                                .frame(height: 52)
                                .background(Color(UIColor.systemMint))
                                .foregroundColor(.white)
                                .cornerRadius(12)
                        } else {
                            Text("Sign In")
                                .font(.system(size: 18, weight: .semibold))
                                .frame(maxWidth: .infinity)
                                .frame(height: 52)
                                .background(Color(UIColor.systemMint))
                                .foregroundColor(.white)
                                .cornerRadius(12)
                                .shadow(color: Color(UIColor.systemMint).opacity(0.5), radius: 10, x: 0, y: 5)
                        }
                    }
                    .disabled(authHandlers.isLoading)
                    .frame(maxWidth: 280)
                    .padding(.vertical, 16)

                    // Google Sign-In Button
                    Button(action: {
                        guard let rootVC = UIApplication.shared.connectedScenes
                                .compactMap({ $0 as? UIWindowScene })
                                .flatMap({ $0.windows })
                                .first(where: { $0.isKeyWindow })?.rootViewController else {
                            authHandlers.errorMessage = "Unable to access root view controller."
                            return
                        }
                        authHandlers.signInWithGoogle(presenting: rootVC) { _ in }
                    }) {
                        HStack(spacing: 12) {
                            Image("Google")
                                .resizable()
                                .frame(width: 22, height: 22)

                            Text("Sign in with Google")
                                .font(.system(size: 17, weight: .medium))
                                .foregroundColor(.black)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.08), radius: 6, x: 0, y: 3)
                    }
                    .disabled(authHandlers.isLoading)
                    .frame(maxWidth: 280)

                    // Signup text
                    Text("Sign up or continue with Google")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                        .padding(.top, 14)

                    // Error message
                    if let errorMessage = authHandlers.errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                            .frame(maxWidth: 320)
                            .padding(.top, 6)
                    }

                    Spacer(minLength: 24)
                }
                .padding(.horizontal, 24)
            }
            .navigationBarHidden(true)
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(FirebaseManager.shared)
    }
}
