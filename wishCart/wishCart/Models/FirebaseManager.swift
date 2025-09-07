import Foundation
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import GoogleSignIn
import UIKit
import SwiftUI

class FirebaseManager: ObservableObject {
    static let shared = FirebaseManager()

    let firestore: Firestore
    let auth: Auth

    @Published var isLoggedIn = false
    @Published var errorMessage: String?
    @Published var isLoading = false

    private init() {
        self.firestore = Firestore.firestore()
        self.auth = Auth.auth()
        
        // Check if user is already logged in on app launch
        self.isLoggedIn = auth.currentUser != nil
    }

    func signInWithEmail(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        self.errorMessage = nil
        self.isLoading = true

        auth.signIn(withEmail: email, password: password) { [weak self] authResult, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                    completion(.failure(error))
                    return
                }
                if let user = authResult?.user {
                    self?.isLoggedIn = true
                    completion(.success(user))
                } else {
                    let unknownError = NSError(domain: "FirebaseManager", code: -1,
                                               userInfo: [NSLocalizedDescriptionKey: "User not found"])
                    self?.errorMessage = unknownError.localizedDescription
                    completion(.failure(unknownError))
                }
            }
        }
    }

    func signInWithGoogle(presenting viewController: UIViewController, completion: @escaping (Result<User, Error>) -> Void) {
        self.errorMessage = nil
        self.isLoading = true

        guard let clientID = FirebaseApp.app()?.options.clientID else {
            let clientIDError = NSError(domain: "FirebaseManager", code: 0,
                                       userInfo: [NSLocalizedDescriptionKey: "Missing Google Client ID"])
            self.errorMessage = clientIDError.localizedDescription
            self.isLoading = false
            completion(.failure(clientIDError))
            return
        }

        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        GIDSignIn.sharedInstance.signIn(withPresenting: viewController) { [weak self] signInResult, error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                    self?.isLoading = false
                    completion(.failure(error))
                    return
                }

                guard let idToken = signInResult?.user.idToken?.tokenString,
                      let accessToken = signInResult?.user.accessToken.tokenString else {
                    let tokenError = NSError(domain: "GoogleSignIn", code: 0,
                                             userInfo: [NSLocalizedDescriptionKey: "Token missing"])
                    self?.errorMessage = tokenError.localizedDescription
                    self?.isLoading = false
                    completion(.failure(tokenError))
                    return
                }

                let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)

                Auth.auth().signIn(with: credential) { authResult, error in
                    self?.isLoading = false
                    if let error = error {
                        self?.errorMessage = error.localizedDescription
                        completion(.failure(error))
                        return
                    }
                    if let user = authResult?.user {
                        self?.isLoggedIn = true
                        completion(.success(user))
                    } else {
                        let unknownError = NSError(domain: "FirebaseManager", code: -1,
                                                   userInfo: [NSLocalizedDescriptionKey: "User not found after Google sign-in"])
                        self?.errorMessage = unknownError.localizedDescription
                        completion(.failure(unknownError))
                    }
                }
            }
        }
    }

    func signOut() {
        do {
            try auth.signOut()
            DispatchQueue.main.async {
                self.isLoggedIn = false
            }
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = "Error signing out: \(error.localizedDescription)"
            }
        }
    }
}
