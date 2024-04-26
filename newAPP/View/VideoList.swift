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
    @Binding var videoIds: [String]
    @Binding var titles: [String]
    @ObservedObject var viewModel: ContentViewModel
    let onVideoTap: (URL) -> Void

    var body: some View {
        List {
            ForEach(Array(zip(searchResults.results.indices, searchResults.results)), id: \.0) { index, result in
                Button(action: {
                    let url = openYouTubeVideo(videoId: videoIds[index])
                    onVideoTap(url)
                }) {
                    HStack {
                        Text(titles[index])
                        Spacer()
                        Text(formatDuration(viewModel.videoDurations[videoIds[index]] ?? 0))
                            .foregroundColor(.gray)
                            .font(.caption)
                    }
                }
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
