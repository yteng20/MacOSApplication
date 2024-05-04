//
//  DataManager.swift
//  newAPP
//
//  Created by Yue Teng on 4/21/24.
//

import Foundation

class DataManager {
    static let shared = DataManager()
    private let videoHistoryFilename = "videoHistory.json"

    func saveVideoHistory(_ videoHistory: [VideoHistoryItem]) {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(videoHistory)
            let url = getDocumentsDirectory().appendingPathComponent(videoHistoryFilename)

            if !FileManager.default.fileExists(atPath: url.path) {
                FileManager.default.createFile(atPath: url.path, contents: nil, attributes: nil)
            }
            //print(data)
            try data.write(to: url)
        } catch {
            print("Error saving video history: \(error.localizedDescription)")
        }
    }

    func loadVideoHistory() -> [VideoHistoryItem] {
        do {
            let url = getDocumentsDirectory().appendingPathComponent(videoHistoryFilename)
            //print(url)
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            return try decoder.decode([VideoHistoryItem].self, from: data)
        } catch {
            print("Error loading video history: \(error.localizedDescription)")
            return []
        }
    }

    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
