//
//  ContentViewModel.swift
//  FitnessTracker
//
//  Created by Yue Teng on 4/24/24.
//

import Foundation
import YouTubeKit
import WebKit

class ContentViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var searchResults: SearchResponse?
    @Published var isLoading: Bool = false
    @Published var videoIds: [String] = []
    @Published var titles: [String] = []
    @Published var videoDurations: [String: TimeInterval] = [:]

    @Published var webView: WKWebView?
    @Published var foods: [FoodItem] = []
    @Published var foodName: String = ""
    @Published var caloriesText: String = ""

    private let YTM = YouTubeModel()

    func searchVideos() {
        isLoading = true

        let dataParameters: [HeadersList.AddQueryInfo.ContentTypes: String] = [
            .query: searchText
        ]

        SearchResponse.sendRequest(youtubeModel: YTM, data: dataParameters) { [weak self] result, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                if let error = error {
                    print("Error searching videos: \(error)")
                } else if let result = result {
                    self?.searchResults = result
                    self?.videoIds = []
                    self?.titles = []
                    for result in result.results {
                        let string = String(describing: result)
                        if let videoId = self?.extractValueAfterSubstring1(in: string, substring: "videoId") {
                            self?.videoIds.append(videoId)
                        }

                        if let title = self?.extractValueAfterSubstring(in: string, substring: "title") {
                            self?.titles.append(title)
                        } else {
                            self?.titles.append("")
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

    func extractValueAfterSubstring1(in string: String, substring: String) -> String? {
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

    func extractValueAfterSubstring(in string: String, substring: String) -> String? {
        let pattern = "\(substring): Optional\\(\"([^\"]+)\"\\)"
        guard let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive) else {
            return nil
        }
        let matches = regex.matches(in: string, range: NSRange(string.startIndex..., in: string))
        for match in matches {
            let range = Range(match.range(at: 1), in: string)!
            return String(string[range])
        }
        return nil
    }

    func extractYouTubeVideoId(from url: URL) -> String? {
        guard let youtubeUrl = URLComponents(string: url.absoluteString) else {
            return nil
        }
        return youtubeUrl.queryItems?.first(where: { $0.name == "v" })?.value
    }
    func loadFoodItems() {
        foods = DataManager.shared.loadFoodItems()
    }

    func addFood() {
        if let calories = Int(caloriesText) {
            let newFood = FoodItem(name: foodName, calories: calories)
            foods.append(newFood)
            foodName = ""
            caloriesText = ""
            DataManager.shared.saveFoodItems(foods)
        }
    }
}
