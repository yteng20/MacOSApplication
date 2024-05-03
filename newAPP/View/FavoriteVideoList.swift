//
//  FavoriteVideoList.swift
//  FitnessTracker
//
//  Created by Yue Teng on 5/3/24.
//

import SwiftUI

struct FavoriteVideoList: View {
    @ObservedObject var viewModel: ContentViewModel
    @State private var isExpanded: Bool = true
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Favorite Videos")
                    .font(.headline)
                Spacer()
                Button(action: { isExpanded.toggle() }) {
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(.gray)
                }
            }
            if isExpanded {
                List {
                    ForEach(viewModel.favoriteVideos, id: \.id) { video in
                        Button(action: {
                            let url = openYouTubeVideo(videoId: video.videoId)
                            viewModel.loadURL(url)
                        }) {
                            HStack {
                                Text(video.title ?? "Unknown Title")
                                Spacer()
                                Text(formatDuration(video.duration))
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
        }
        .padding()
        .onChange(of: viewModel.videoHistory) { _ in
            updateFavoriteVideos()
        }
    }
    
    func openYouTubeVideo(videoId: String) -> URL {
        let url = URL(string: "https://www.youtube.com/watch?v=\(videoId)")!
        return url
    }
    
    func formatDuration(_ duration: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        return formatter.string(from: duration) ?? ""
    }
    
    func updateFavoriteVideos() {
        viewModel.favoriteVideos = viewModel.videoHistory.filter { $0.isFavorite }
    }
}
