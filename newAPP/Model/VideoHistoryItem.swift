//
//  FoodItem.swift
//  newAPP
//
//  Created by Yue Teng on 4/21/24.
//

import Foundation

struct VideoHistoryItem: Identifiable, Encodable, Decodable, Equatable {
    var id = UUID()
    let title: String?
    let videoId: String
    let duration: TimeInterval
    var isFavorite: Bool = false
}
