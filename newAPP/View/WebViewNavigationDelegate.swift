//
//  WebViewNavigationDelegate.swift
//  newAPP
//
//  Created by Yue Teng on 4/26/24.
//

import ObjectiveC
import WebKit

class WebViewNavigationDelegate: NSObject, WKNavigationDelegate {
    let viewModel: ContentViewModel

    init(viewModel: ContentViewModel) {
        self.viewModel = viewModel
    }

    private var startTime: Date?
    private var currentVideoId: String?

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        if let url = webView.url, url.host == "www.youtube.com" {
            currentVideoId = viewModel.extractYouTubeVideoId(from: url)
            startTime = Date()
        }
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if let videoId = currentVideoId, let start = startTime {
            let duration = Date().timeIntervalSince(start)
            viewModel.videoDurations[videoId] = (viewModel.videoDurations[videoId] ?? 0) + duration
            
            let index = viewModel.videoIds.firstIndex(of: videoId) ?? 0
            let title = viewModel.titles[index]
            viewModel.videoHistory.append((id: UUID(), title: title, duration: duration))
            
            currentVideoId = nil
            startTime = nil
        }
    }
}
