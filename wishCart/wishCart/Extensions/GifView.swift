//
//  GifView.swift
//  wishCart
//
//  Created by Manan Gurung on 05/08/25.
//

import SwiftUI
import WebKit

struct GifView: UIViewRepresentable {
    let gifName: String

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        if let path = Bundle.main.path(forResource: gifName, ofType: "gif") {
            let gifData = try? Data(contentsOf: URL(fileURLWithPath: path))
            webView.load(gifData ?? Data(), mimeType: "image/gif", characterEncodingName: "UTF-8", baseURL: URL(string: "about:blank")!)
            webView.scrollView.isScrollEnabled = false
            webView.backgroundColor = .clear
            webView.isOpaque = false
        }
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {}
}
