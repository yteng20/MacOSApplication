//
//  ContentView.swift
//  newAPP
//
//  Created by Yue Teng on 4/14/24.
//

import SwiftUI
import YouTubeKit

struct ContentView: View {
    private var YTM = YouTubeModel()
    @State private var text: String = ""
    @State private var searchResults: SearchResponse?
    @State private var isLoading: Bool = false
    @State private var videoIds: [String] = []
    @State private var titles: [String] = []

    var body: some View {
        VStack {
            HStack {
                TextField("Search", text: $text)
                    .padding()

                Button("Search") {
                    searchVideos()
                }
                .padding()
            }

            if isLoading {
                ProgressView()
            }

            Divider()

            if let searchResults = searchResults {
                LazyVGrid(columns: Array(repeating: GridItem(), count: 3), spacing: 20) {
                    ForEach(0..<searchResults.results.count, id: \.self) { index in
                        Button(action: {
                            openYouTubeVideo(videoId: videoIds[index])
                        }) {
                            VStack {
                                // Display the thumbnail image here
                                /*Image(systemName: "play.circle.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 100, height: 100)
                                    .foregroundColor(.blue)*/

                                Text(titles[index])
                                    .font(.caption)
                                    .foregroundColor(.black)
                            }
                        }
                    }
                }
                .padding()
            }
        }
        .padding()
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
                            //print(videoId)
                            videoIds.append(videoId)
                        } else {
                            print("Video ID not found.")
                        }

                        if let title = extractValueAfterSubstring(in: string, substring: "title") {
                            //print("title: ")
                            //print(title)
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

    func openYouTubeVideo(videoId: String) {
        let url = URL(string: "https://www.youtube.com/watch?v=\(videoId)")!
        NSWorkspace.shared.open(url)
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
