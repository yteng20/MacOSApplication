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
            DietView(viewModel: viewModel)
        }
        .padding()
        .onAppear {
            viewModel.loadFoodItems()
        }
    }
}
