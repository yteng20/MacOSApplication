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
                FavoriteVideoList(viewModel: viewModel)
                if let searchResults = viewModel.searchResults {
                    VideoList(searchResults: searchResults,
                              //videoIds: $viewModel.videoIds,
                              //titles: $viewModel.titles,
                              viewModel: viewModel,
                              onVideoTap: viewModel.loadURL)
                }
            }
            if let webView = viewModel.webView {
                WebViewContainer(viewModel: viewModel, webView: webView)
                    //.frame(width: 640, height: 360)
                    .frame(minWidth: 640, maxWidth: .infinity, minHeight: 360, maxHeight: .infinity)
            }
            VideoHistory(viewModel: viewModel)
        }
        .padding()
        .onAppear {
            viewModel.loadVideoHistory()
        }
    }
}

struct VideoHistory: View {
    @ObservedObject var viewModel: ContentViewModel

        var body: some View {
            VStack {
                Text("Video History")
                    .font(.title)
                List {
                    ForEach(viewModel.videoHistory.sorted { $0.isFavorite && !$1.isFavorite }, id: \.id) { video in
                        HStack {
                            NavigationLink(destination: EmptyView()) {
                                HStack {
                                    if let title = video.title {
                                        Text(title)
                                            .foregroundColor(.blue)
                                            .underline()
                                    } else {
                                        Text("Unknown Title")
                                    }
                                    Spacer()
                                    Text(formatDuration(video.duration))
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                            }
                            .onTapGesture {
                                let url = openYouTubeVideo(videoId: video.videoId)
                                viewModel.loadURL(url)
                            }
                            
                            Button(action: {
                                toggleFavorite(for: video)
                            }) {
                                Image(systemName: video.isFavorite ? "star.fill" : "star")
                                    .foregroundColor(.yellow)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        Divider()
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
                .cornerRadius(10)

                Text("Video Watch Time")
                    .font(.title)

                if !viewModel.videoDurations.isEmpty {
                    PieChart(data: viewModel.videoDurations.map { Double($0.value) },
                             colors: [.red, .green, .blue, .orange, .purple])
                        .aspectRatio(1, contentMode: .fit)
                        .padding()
                }
            }
            .padding()
            .frame(minWidth: 300)
        }
    
    func openYouTubeVideo(videoId: String) -> URL {
        let url = URL(string: "https://www.youtube.com/watch?v=\(videoId)")!
        return url
    }

    func toggleFavorite(for video: VideoHistoryItem) {
        if let index = viewModel.videoHistory.firstIndex(where: { $0.id == video.id }) {
            var updatedVideo = video
            updatedVideo.isFavorite.toggle()
            viewModel.videoHistory.remove(at: index)
            viewModel.videoHistory.insert(updatedVideo, at: 0)
            viewModel.videoHistory.sort { $0.isFavorite && !$1.isFavorite }
        }
    }

    func formatDuration(_ duration: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        return formatter.string(from: duration) ?? ""
    }
}
