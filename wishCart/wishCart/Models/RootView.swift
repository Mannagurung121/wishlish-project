//
//  RootView.swift
//  wishCart
//
//  Created by Manan Gurung on 10/08/25.
//

import SwiftUI

struct RootView: View {
    @EnvironmentObject var authVM: FirebaseManager

    var body: some View {
        Group {
            if authVM.isLoggedIn {
                HomePage()
            } else {
                LoginView()
            }
        }
    }
}
