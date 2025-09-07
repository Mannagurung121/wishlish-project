//
//  Button.swift
//  wishCart
//
//  Created by Manan Gurung on 26/07/25.
//

import SwiftUI

struct Btn: View {
    var body: some View {
        VStack{
            Button(action: {
                print("Sign In tapped")
            }) {
                Text("Sign In")
                    .font(.system(size: 16, weight: .bold))
                    .frame(maxWidth: 300)
                    .frame(height: 50)
                    .foregroundColor(.white)
            }
            .background(Color.mint)
            .cornerRadius(10)
            .padding(.horizontal, 20)
        }
        
        
    }
}

#Preview {
    Btn()
}
