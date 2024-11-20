//
//  FlickrFeedResponse.swift
//  FlickrDemo
//
//  Created by Malek Saadeh on 11/19/24.
//

import Foundation

/// API Response
struct FlickrFeedResponse: Codable {
    let items: [FlickrImage]
}

/// Image Model
struct FlickrImage: Identifiable, Codable {
    let id = UUID()
    let title: String
    let link: String
    let media: MediaLink
    let description: String
    let author: String
    let published: String
    
    struct MediaLink: Codable {
        let m: String
    }
    
    var thumbnailURL: URL? {
        return URL(string: media.m)
    }
    
    var largeImageURL: URL? {
        return URL(string: media.m.replacingOccurrences(of: "_m", with: ""))
    }
}

/// extension to add dimensions!
extension FlickrImage {
    // TODO: remove
    var imageDimensions: (width: Int, height: Int)? {
        parseDimensions()
    }
    
    // gets dimensions from the description
    private func parseDimensions() -> (width: Int, height: Int)? {
        
        let widthModel = #"width="?(\d+)"?"#
        let heightModel = #"height="?(\d+)"?"#
        
        do {
            let widthRegex = try NSRegularExpression(pattern: widthModel, options: [])
            let heightRegex = try NSRegularExpression(pattern: heightModel, options: [])
            
            let nsDescription = description as NSString
            
            let widthMatches = widthRegex.matches(
                in: description,
                range: NSRange(location: 0, length: nsDescription.length)
            )
            
            let heightMatches = heightRegex.matches(
                in: description,
                range: NSRange(location: 0, length: nsDescription.length)
            )
            
            // width and height values
            if let widthMatch = widthMatches.first,
               let heightMatch = heightMatches.first,
               widthMatch.numberOfRanges > 1,
               heightMatch.numberOfRanges > 1 {
                
                let widthRange = widthMatch.range(at: 1)
                let heightRange = heightMatch.range(at: 1)
                
                let width = Int(nsDescription.substring(with: widthRange)) ?? 0
                let height = Int(nsDescription.substring(with: heightRange)) ?? 0
                
                return (width, height)
            }
        }
        catch {
            print("Error getting dimensions: \(error)")
        }
        return nil
    }
}
