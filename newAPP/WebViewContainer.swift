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
    let webView: WKWebView

    func makeNSView(context: Context) -> WKWebView {
        return webView
    }

    func updateNSView(_ nsView: WKWebView, context: Context) {
    }
}
