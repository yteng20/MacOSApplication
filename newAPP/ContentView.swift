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
    @State private var foods: [FoodItem] = []
    @State private var foodName: String = ""
    @State private var caloriesText: String = ""
    
    init() {
        foods = DataManager.shared.loadFoodItems()
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                HStack {
                    TextField("Search", text: $text)
                        .padding()
                        .frame(width: 150)
                    
                    Button("Search") {
                        searchVideos()
                    }
                    .padding()
                    .frame(minWidth: 100)
                }
                .padding()
                
                if isLoading {
                    ProgressView()
                }
                
                if let searchResults = searchResults {
                    List(0..<searchResults.results.count, id: \.self) { index in
                        Button(action: {
                            let url = openYouTubeVideo(videoId: videoIds[index])
                            loadURL(url)
                        }) {
                            Text(titles[index])
                        }
                    }
                    .frame(maxWidth: 300)
                }
            }
            
            if let webView = webView {
                WebViewContainer(webView: webView)
                    .frame(width: 640, height: 360)
            }
            
            VStack {
                Text("Diet")
                    .font(.title)
                
                HStack {
                    TextField("Food Name", text: $foodName)
                        .padding()
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    TextField("Calories", text: $caloriesText)
                        .padding()
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Button("Add Food") {
                        if let calories = Int(caloriesText) {
                            let newFood = FoodItem(name: foodName, calories: calories)
                            foods.append(newFood)
                            foodName = ""
                            caloriesText = ""
                            DataManager.shared.saveFoodItems(foods)
                        }
                    }
                    .padding()
                    .cornerRadius(10)
                }
                
                List(foods) { food in
                    VStack(alignment: .leading) {
                        Text(food.name)
                        Text("\(food.calories) calories")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
                .cornerRadius(10)
                
                if !foods.isEmpty {
                    PieChart(data: foods.map { Double($0.calories) }, colors: [.red, .green, .blue, .orange, .purple])
                        .aspectRatio(1, contentMode: .fit)
                        .padding()
                }
                
                Text("Workout")
                    .font(.title)
                    .padding()
                    .background(Color.orange.opacity(0.3))
                    .cornerRadius(5)
            }
            .padding()
            .frame(minWidth: 300)
        }
        .padding()
        .onAppear {
            foods = DataManager.shared.loadFoodItems()
        }
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
                        if let videoId = extractValueAfterSubstring1(in: string, substring: "videoId") {
                            videoIds.append(videoId)
                        } else {
                            //print("Video ID not found.")
                        }

                        if let title = extractValueAfterSubstring(in: string, substring: "title") {
                            titles.append(title)
                        } else {
                            //print("Video title not found.")
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
}
