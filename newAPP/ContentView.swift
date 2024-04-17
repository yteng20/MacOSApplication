//
//  ContentView.swift
//  newAPP
//
//  Created by Yue Teng on 4/14/24.
//

import SwiftUI
import YouTubeKit
import WebKit

struct ContentView: View {
    private var YTM = YouTubeModel()
    @State private var text: String = ""
    @State private var searchResults: SearchResponse?
    @State private var isLoading: Bool = false
    @State private var videoIds: [String] = []
    @State private var titles: [String] = []
    @State private var webView: WKWebView?

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
                    LazyVGrid(columns: Array(repeating: GridItem(), count: 10), spacing: 20) {
                        ForEach(0..<searchResults.results.count, id: \.self) { index in
                            Button(action: {
                                let url = openYouTubeVideo(videoId: videoIds[index])
                                loadURL(url)
                            }) {
                                VStack {
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
            .frame(width: 300, height: 200)

            if let webView = webView {
                WebViewContainer(webView: webView)
                    .frame(height: 300)
            }

            Divider()
            VStack {
                HStack {
                    Text("diet")
                    Divider()
                    Text("workout")
                }
            }
            Spacer()
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
    
    func loadURL(_ url: URL) {
        if webView == nil {
            webView = WKWebView()
        }
        let request = URLRequest(url: url)
        webView?.load(request)
    }

    func openYouTubeVideo(videoId: String) -> URL {
        let url = URL(string: "https://www.youtube.com/watch?v=\(videoId)")!
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

struct WebViewContainer: NSViewRepresentable {
    let webView: WKWebView

    func makeNSView(context: Context) -> WKWebView {
        return webView
    }

    func updateNSView(_ nsView: WKWebView, context: Context) {
    }
}
 
