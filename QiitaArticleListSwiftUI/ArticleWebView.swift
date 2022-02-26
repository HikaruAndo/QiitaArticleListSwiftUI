//
//  ArticleWebView.swift
//  QiitaArticleListSwiftUI
//
//  Created by AndoHikaru on 2022/02/26.
//

import Foundation
import SwiftUI
import WebKit

struct ArticleWebView: UIViewRepresentable {
    let url: String
    
    func makeUIView(context: Context) -> WKWebView {
        WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.load(URLRequest(url: URL(string: url)!))
    }
}
