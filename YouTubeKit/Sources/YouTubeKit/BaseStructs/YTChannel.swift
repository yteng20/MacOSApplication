//
//  YTChannel.swift
//
//  Created by Antoine Bollengier (github.com/b5i) on 22.06.2023.
//  Copyright © 2023 - 2024 Antoine Bollengier. All rights reserved.
//  

import Foundation


/// Struct representing a channel.
public struct YTChannel: YTSearchResult, YouTubeChannel {
    public init(id: Int? = nil, name: String? = nil, channelId: String, handle: String? = nil, thumbnails: [YTThumbnail] = [], subscriberCount: String? = nil, badges: [String] = []) {
        self.id = id
        self.name = name
        self.channelId = channelId
        self.handle = handle
        self.thumbnails = thumbnails
        self.subscriberCount = subscriberCount
        self.badges = badges
    }
    
    public static func canBeDecoded(json: JSON) -> Bool {
        return json["channelId"].string != nil
    }
    
    public static func decodeJSON(json: JSON) -> YTChannel? {
        /// Check if the JSON can be decoded as a Channel.
        guard let channelId = json["channelId"].string else { return nil }

        /// Inititalize a new ``YTSearchResultType/Channel-swift.struct`` instance to put the informations in it.
        var channel = YTChannel(channelId: channelId)
        channel.name = json["title"]["simpleText"].string
        channel.handle = json["subscriberCountText"]["simpleText"].string
                    
        YTThumbnail.appendThumbnails(json: json["thumbnail"], thumbnailList: &channel.thumbnails)
        
        /// There's an error in YouTube's API
        channel.subscriberCount = json["videoCountText"]["simpleText"].string
        
        if let badgesList = json["ownerBadges"].array {
            for badge in badgesList {
                if let badgeName = badge["metadataBadgeRenderer"]["style"].string {
                    channel.badges.append(badgeName)
                }
            }
        }
        
        return channel
    }
    
    public static var type: YTSearchResultType = .channel
    
    public var id: Int?
    
    /// Channel's name.
    public var name: String?
    
    /// Channel's handle.
    public var handle: String?
    
    /// Channel's identifier, can be used to get the informations about the channel.
    ///
    /// For example:
    /// ```swift
    /// let YTM = YouTubeModel()
    /// let channelId: String = ...
    /// ChannelInfosResponse.sendNonThrowingRequest(youtubeModel: YTM, data: [.browseId : channelId], result: { result in
    ///      print(result)
    /// })
    /// ```
    public var channelId: String
    
    /// Array of thumbnails representing the avatar of the channel.
    ///
    /// Usually sorted by resolution, from low to high.
    public var thumbnails: [YTThumbnail] = []
    
    /// Channel's subscribers count.
    ///
    /// Usually like "123k subscribers".
    public var subscriberCount: String?
    
    /// Array of string identifiers of the badges that a channel has.
    ///
    /// Usually like "BADGE_STYLE_TYPE_VERIFIED"
    public var badges: [String] = []
    
    ///Not necessary here because of prepareJSON() method
    /*
    enum CodingKeys: String, CodingKey {
        case name
        case stringIdentifier
        case thumbnails
        case subscriberCount
        case badges
    }
     */
}
