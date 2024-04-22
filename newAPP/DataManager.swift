//
//  DataManager.swift
//  newAPP
//
//  Created by Yue Teng on 4/21/24.
//

import Foundation

class DataManager {
    static let shared = DataManager()
    
    private let filename = "foodItems.json"
    
    func saveFoodItems(_ foodItems: [FoodItem]) {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(foodItems)
            let url = getDocumentsDirectory().appendingPathComponent(filename)
            if !FileManager.default.fileExists(atPath: url.path) {
                FileManager.default.createFile(atPath: url.path, contents: nil, attributes: nil)
            }
            try data.write(to: url)
        } catch {
            print("Error saving food items: \(error.localizedDescription)")
        }
    }
    
    func loadFoodItems() -> [FoodItem] {
        do {
            let url = getDocumentsDirectory().appendingPathComponent(filename)
            //print(url)
            let data = try Data(contentsOf: url)
            //print(type(of: data))
            let decoder = JSONDecoder()
            let foodItems = try decoder.decode([FoodItem].self, from: data)
            //print(type(of: foodItems))
            return foodItems
        } catch {
            print("Error loading food items: \(error.localizedDescription)")
            return []
        }
    }
    
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
