//
//  Environment.swift
//  FlickrDemo
//
//  Created by Malek Saadeh on 11/19/24.
//

import Foundation

enum Environment {
    private enum Path {
        static let imagePath = "https://api.flickr.com/services/feeds/photos_public.gne"
    }
    
    case search(_ tags: String)
    
    var request: URLRequest? {
        switch self {
        case .search(let tags):
            guard var components = URLComponents(string: Path.imagePath) else {
                return nil
            }
            components.queryItems = [
                URLQueryItem(name: "format", value: "json"),
                URLQueryItem(name: "nojsoncallback", value: "1"),
                URLQueryItem(name: "tags", value: sanitize(tags: tags))
            ]
            guard let url = components.url else {
                return nil
            }
            return URLRequest(url: url)
        }
    }
    
    private func sanitize(tags: String) -> String {
        let sanitizedTags = tags.replacingOccurrences(of: " ", with: ",")
        return sanitizedTags.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
    }
}
