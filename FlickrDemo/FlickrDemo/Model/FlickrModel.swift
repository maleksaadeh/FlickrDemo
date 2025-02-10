//
//  FlickrModel.swift
//  FlickrDemo
//
//  Created by uuser on 2/7/25.
//

import Foundation

struct FlickrModel: Codable {
    
    let id: UUID
    let title: String
    let link: String
    let media: Media
    let dateTaken: String
    let description: String
    let published: String
    let author: String
    let authorID: String
    let tags: String
    

    enum CodingKeys: String, CodingKey {
        
        case title, link, media, description, published, author, tags
        case dateTaken = "date_taken"
        case authorID = "author_id"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.title = try container.decode(String.self, forKey: .title)
        self.link = try container.decode(String.self, forKey: .link)
        self.media = try container.decode(Media.self, forKey: .media)
        self.dateTaken = try container.decode(String.self, forKey: .dateTaken)
        self.description = try container.decode(String.self, forKey: .description)
        self.published = try container.decode(String.self, forKey: .published)
        self.author = try container.decode(String.self, forKey: .author)
        self.authorID = try container.decode(String.self, forKey: .authorID)
        self.tags = try container.decode(String.self, forKey: .tags)

        self.id = UUID()
    }
}

struct Media: Codable {
    let m: String
}

extension FlickrModel: Identifiable {
    
    static func == (leftSide: FlickrModel, rightSide: FlickrModel) -> Bool {
        leftSide.id == rightSide.id
    }
}
