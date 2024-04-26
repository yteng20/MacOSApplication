//
//  ContentView.swift
//  newAPP
//
//  Created by Yue Teng on 4/14/24.
//

import SwiftUI
import WebKit

struct ContentView: View {
    @StateObject private var viewModel = ContentViewModel()

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                SearchBar(text: $viewModel.searchText, onSearch: viewModel.searchVideos)
                if viewModel.isLoading {
                    ProgressView()
                }
                if let searchResults = viewModel.searchResults {
                    VideoList(searchResults: searchResults,
                              videoIds: $viewModel.videoIds,
                              titles: $viewModel.titles,
                              viewModel: viewModel,
                              onVideoTap: viewModel.loadURL)
                }
            }
            if let webView = viewModel.webView {
                WebViewContainer(viewModel: viewModel, webView: webView)
                    .frame(width: 640, height: 360)
            }
            VideoHistory(viewModel: viewModel)
        }
        .padding()
    }
}

struct VideoHistory: View {
    @ObservedObject var viewModel: ContentViewModel

    var body: some View {
        VStack {
            Text("Video History")
                .font(.title)
            List {
                ForEach(viewModel.videoHistory, id: \.id) { video in
                    HStack {
                        if let title = video.title {
                            Text(title)
                        } else {
                            Text("Unknown Title")
                        }
                        Spacer()
                        Text(formatDuration(video.duration))
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .cornerRadius(10)
        }
        .padding()
        .frame(minWidth: 300)
    }

    func formatDuration(_ duration: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        return formatter.string(from: duration) ?? ""
    }
}
