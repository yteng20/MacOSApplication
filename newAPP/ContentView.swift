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
        VStack {
            HStack {
                TextField("Search", text: $text)
                    .padding()
                    .frame(width: 100)

                Button("Search") {
                    searchVideos()
                }
                .padding()
                .frame(width: 100)

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
            .frame(height: 200)
            .background(Color.blue.opacity(0.1))
            .cornerRadius(10)
            .padding()

            if let webView = webView {
                WebViewContainer(webView: webView)
                    .frame(height: 300)
            }

            Divider()
            HStack {
                Text("Diet")
                VStack {
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
                }

                Divider()

                Text("Workout")
                    .padding()
                    .background(Color.orange.opacity(0.3))
                    .cornerRadius(5)
            }
            .padding()
            .cornerRadius(10)
            .padding()

            Spacer()
        }
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
                        if let videoId = extractValueAfterSubstring(in: string, substring: "videoId") {
                            videoIds.append(videoId)
                        } else {
                            //print("Video ID not found.")
                        }

                        if let title = extractValueAfterSubstring(in: string, substring: "title") {
                            titles.append(title)
                        } else {
                            titles.append("")
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
