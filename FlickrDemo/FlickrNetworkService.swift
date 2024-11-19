//
//  FlickrNetworkService.swift
//  FlickrDemo
//
//  Created by Malek Saadeh on 11/19/24.
//

import Foundation
import Combine
import SwiftUI

class FlickrNetworkService {
    static let shared = FlickrNetworkService()
    private var cancellables = Set<AnyCancellable>()
    
    func searchImages(tags: String, completion: @escaping ([FlickrImage]) -> Void) {
        // Sanitize and encode tags
        let sanitizedTags = tags.replacingOccurrences(of: " ", with: ",")
        let encodedTags = sanitizedTags.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        guard let url = URL(string: "https://api.flickr.com/services/feeds/photos_public.gne?format=json&nojsoncallback=1&tags=\(encodedTags)") else {
            completion([])
            return
        }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: FlickrFeedResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure:
                    print("Error fetching images")
                case .finished:
                    break
                }
            }, receiveValue: { response in
                completion(response.items)
            })
            .store(in: &cancellables)
    }
}
