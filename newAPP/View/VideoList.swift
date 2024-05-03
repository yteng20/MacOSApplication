//
//  VideoList.swift
//  FitnessTracker
//
//  Created by Yue Teng on 4/24/24.
//

import SwiftUI
import YouTubeKit

struct VideoList: View {
    let searchResults: SearchResponse
    @ObservedObject var viewModel: ContentViewModel
    let onVideoTap: (URL) -> Void

    var body: some View {
        List {
            ForEach(zip(searchResults.results, zip(viewModel.videoIds, viewModel.titles)).filter { !$0.1.0.isEmpty && !$0.1.1.isEmpty }, id: \.0.id) { result, idAndTitle in
                let (videoId, title) = idAndTitle
                Button(action: {
                    let url = openYouTubeVideo(videoId: videoId)
                    onVideoTap(url)
                }) {
                    HStack {
                        Text(title)
                        Spacer()
                        Text(formatDuration(viewModel.videoDurations[videoId] ?? 0))
                            .foregroundColor(.gray)
                            .font(.caption)
                    }
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .frame(maxWidth: 300)
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
}
