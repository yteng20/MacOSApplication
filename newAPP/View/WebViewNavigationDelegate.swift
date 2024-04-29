//
//  WebViewNavigationDelegate.swift
//  newAPP
//
//  Created by Yue Teng on 4/26/24.
//

import WebKit
import SwiftUI

class WebViewNavigationDelegate: NSObject, WKNavigationDelegate {
    let viewModel: ContentViewModel
    private var isVideoPlaying: Bool = false
    private var startTime: Date?
    private var currentVideoId: String?
    private var videoHistoryReference: Binding<[VideoHistoryItem]>?

    init(viewModel: ContentViewModel, videoHistoryReference: Binding<[VideoHistoryItem]>?) {
        self.viewModel = viewModel
        self.videoHistoryReference = videoHistoryReference
    }

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        if let url = webView.url, url.host == "www.youtube.com" {
            currentVideoId = viewModel.extractYouTubeVideoId(from: url)
            startTime = Date()
            isVideoPlaying = true
        }
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if isVideoPlaying, let videoId = currentVideoId, let start = startTime {
            let duration = Date().timeIntervalSince(start)

            let index = viewModel.videoIds.firstIndex(of: videoId) ?? 0
            let title = viewModel.titles[index]

            let videoHistoryItem = VideoHistoryItem(id: UUID(), title: title, videoId: videoId, duration: duration)
            videoHistoryReference?.wrappedValue.append(videoHistoryItem)
            viewModel.videoDurations[videoId] = duration

            currentVideoId = nil
            startTime = nil
            isVideoPlaying = false
        }
    }
}
