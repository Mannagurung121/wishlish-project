//
//  wishCartApp.swift
//  wishCart
//
//  Created by Manan Gurung on 26/07/25.
//

import SwiftUI
import FirebaseCore
import GoogleSignIn

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
    
    func application(_ app: UIApplication, open url: URL,
                     options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }
}

@main
struct wishCartApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(FirebaseManager.shared)
        }
    }
}
