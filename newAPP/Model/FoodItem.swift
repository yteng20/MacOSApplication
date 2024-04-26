//
//  FoodItem.swift
//  newAPP
//
//  Created by Yue Teng on 4/21/24.
//

import Foundation

struct FoodItem: Identifiable, Encodable, Decodable {   
    var id = UUID()
    let name: String
    let calories: Int
}
