//
//  Lottie.swift
//  wishCart
//
//  Created by Manan Gurung on 05/08/25.
//

import SwiftUI
import Lottie

struct LottieView: UIViewRepresentable {
    var filename: String
    var loopMode: LottieLoopMode = .loop

    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        let animationView = LottieAnimationView(name: filename)
        animationView.loopMode = loopMode
        animationView.contentMode = .scaleAspectFit
        animationView.play()

        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)

        NSLayoutConstraint.activate([
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor),
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])

        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}
