//
//  ContentView.swift
//  FlickrDemo
//
//  Created by Malek Saadeh on 11/19/24.

import Foundation
import SwiftUI
import Combine

// MARK: - Image Model
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
    
    var imageDimensions: (width: Int, height: Int)? {
        if let finalDimensions = parseDimensions() {
            return finalDimensions
        }
        else {
            return nil
        }
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

/// API Response
struct FlickrFeedResponse: Codable {
    let items: [FlickrImage]
}

/// htmlStripping String
extension String {
    var htmlStripped: String {
        guard let data = self.data(using: .utf8) else { return self }
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        
        do {
            let attributedString = try NSAttributedString(data: data, options: options, documentAttributes: nil)
            return attributedString.string
        } catch {
            return self
        }
    }
}

/// Search View
struct ContentView: View {
    @State private var searchText = ""
    @State private var images: [FlickrImage] = []
    @State private var isLoading = false
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $searchText)
                    .onChange(of: searchText) { _ in searchImages() }
                
                if isLoading {
                    ProgressView()
                } else {
                    ScrollView {
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: 8) {
                            ForEach(images) { image in
                                NavigationLink(destination: ImageDetailView(image: image)) {
                                    AsyncImage(url: image.thumbnailURL) { phase in
                                        switch phase {
                                        case .success(let image):
                                            image.resizable().aspectRatio(contentMode: .fill)
                                                .aspectRatio(contentMode: .fill)
                                            
                                        case .failure:
                                            Color.gray
                                        case .empty:
                                            ProgressView()
                                        @unknown default:
                                            fatalError()
                                        }
                                    }
                                    .frame(height: 110)
                                    .cornerRadius(8)
                                }
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Flickr CVS Demo")
            .font(.largeTitle)
        }
    }
    
    private func searchImages() {
        guard !searchText.isEmpty else {
            images = []
            return
        }
        
        isLoading = true
        FlickrNetworkService.shared.searchImages(tags: searchText) { fetchedImages in
            self.images = fetchedImages
            self.isLoading = false
        }
    }
}

/// Search Bar
struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
            TextField("Search images", text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }
        .padding()
    }
}

@main
struct FlickrDemoApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
