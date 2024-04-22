//
//  YouTubeVideo.swift
//  newAPP
//
//  Created by Yue Teng on 4/21/24.
//

import Foundation

struct YouTubeVideo: Codable {
    let id: Int?
    let videoId: String?
    let title: String?
    let channel: Channel?
    let viewCount: String?
    let timePosted: String?
    let timeLength: String?
    let thumbnails: [Thumbnail]?

    struct Channel: Codable {
        let channelId: String?
        let name: String?
        let thumbnails: [Thumbnail]?

        enum CodingKeys: String, CodingKey {
            case channelId, name
            case thumbnails = "thumbnails"
        }

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            channelId = try container.decodeIfPresent(String.self, forKey: .channelId)
            name = try container.decodeIfPresent(String.self, forKey: .name)
            thumbnails = try container.decodeIfPresent([Thumbnail].self, forKey: .thumbnails)
        }
    }

    struct Thumbnail: Codable {
        let width: Int?
        let height: Int?
        let url: URL?

        enum CodingKeys: String, CodingKey {
            case width, height
            case url = "url"
        }

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            width = try container.decodeIfPresent(Int.self, forKey: .width)
            height = try container.decodeIfPresent(Int.self, forKey: .height)
            let urlString = try container.decode(String.self, forKey: .url)
            url = URL(string: urlString)
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encodeIfPresent(width, forKey: .width)
            try container.encodeIfPresent(height, forKey: .height)
            try container.encode(url?.absoluteString, forKey: .url)
        }
    }
}
