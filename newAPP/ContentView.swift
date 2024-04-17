//
//  ContentView.swift
//  newAPP
//
//  Created by Yue Teng on 4/14/24.
//

import SwiftUI
import YouTubeKit
import AVKit

struct ContentView: View {
    private var YTM = YouTubeModel()
    @State private var text: String = ""
    @State private var searchResults: SearchResponse?
    @State private var isLoading: Bool = false
    @State private var videoIds: [String] = []
    @State private var titles: [String] = []
    @State private var avPlayer: AVPlayer?

    var body: some View {
        VStack {
            HStack {
                TextField("Search", text: $text)
                    .padding()
                
                Button("Search") {
                    searchVideos()
                }
                .padding()
                
                if isLoading {
                    ProgressView()
                }
                
                Divider()
                
                if let searchResults = searchResults {
                    LazyVGrid(columns: Array(repeating: GridItem(), count: 3), spacing: 20) {
                        ForEach(0..<searchResults.results.count, id: \.self) { index in
                            Button(action: {
                                let url = openYouTubeVideo(videoId: videoIds[index])
                                print(url)
                                let player = AVPlayer(url: url)
                                self.avPlayer = player
                            }) {
                                VStack {
                                    Text(videoIds[index])
                                        .font(.caption)
                                        .foregroundColor(.black)
                                }
                            }
                        }
                    }
                    .padding()
                }
                
                if let avPlayer = avPlayer {
                    Divider()
                    VideoPlayerContainer(player: avPlayer)
                        .frame(width: 500)
                }
            }
            .frame(width: 300, height: 500)
            
            
            Divider()
            HStack {
                Text("diet")
                Divider()
                Text("workout")
            }
            
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    func searchVideos() {
        isLoading = true

        let dataParameters: [HeadersList.AddQueryInfo.ContentTypes: String] = [
            .query: text
        ]

        SearchResponse.sendRequest(youtubeModel: YTM, data: dataParameters) { result, error in
            DispatchQueue.main.async {
                isLoading = false
                if let error = error {
                    print("Error searching videos: \(error)")
                } else if let result = result {
                    searchResults = result

                    for result in result.results {
                        let string = String(describing: result)
                        if let videoId = extractValueAfterSubstring(in: string, substring: "videoId") {
                            videoIds.append(videoId)
                        } else {
                            print("Video ID not found.")
                        }

                        if let title = extractValueAfterSubstring(in: string, substring: "title") {
                            titles.append(title)
                        } else {
                            titles.append("")
                            print("Video title not found.")
                        }
                    }
                }
            }
        }
    }

    func openYouTubeVideo(videoId: String) -> URL {
        let url = URL(string: "https://www.youtube.com/watch?v=\(videoId)")!
        print(url)
        return url
    }

    func extractValueAfterSubstring(in string: String, substring: String) -> String? {
        let pattern = "\(substring): \"([^\"]+)\""
        guard let regex = try? NSRegularExpression(pattern: pattern) else {
            return nil
        }
        let matches = regex.matches(in: string, range: NSRange(string.startIndex..., in: string))
        for match in matches {
            let range = Range(match.range(at: 1), in: string)!
            return String(string[range])
        }
        return nil
    }
}

struct VideoPlayerContainer: NSViewRepresentable {
    let player: AVPlayer

    func makeNSView(context: Context) -> AVPlayerView {
        let view = AVPlayerView()
        view.player = player
        return view
    }

    func updateNSView(_ nsView: AVPlayerView, context: Context) {}
}
