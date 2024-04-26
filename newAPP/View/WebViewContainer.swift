//
//  WebViewContainer.swift
//  newAPP
//
//  Created by Yue Teng on 4/17/24.
//

import Foundation
import SwiftUI
import WebKit

struct WebViewContainer: NSViewRepresentable {
    @ObservedObject var viewModel: ContentViewModel
    let webView: WKWebView
    private let navigationDelegate: WebViewNavigationDelegate

    init(viewModel: ContentViewModel, webView: WKWebView) {
        self.viewModel = viewModel
        self.webView = webView
        self.navigationDelegate = WebViewNavigationDelegate(viewModel: viewModel)
        setupNavigationObservers()
    }

    func makeNSView(context: Context) -> WKWebView {
        return webView
    }

    func updateNSView(_ nsView: WKWebView, context: Context) {
    }

    private func setupNavigationObservers() {
        webView.navigationDelegate = navigationDelegate as any WKNavigationDelegate
    }
}
