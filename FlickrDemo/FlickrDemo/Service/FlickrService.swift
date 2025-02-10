//
//  FlickrService.swift
//  FlickrDemo
//
//  Created by uuser on 2/7/25.
//

import Foundation

import Foundation

protocol ServiceProtocol {
    func fetchData(for tag: String) async throws -> [FlickrModel]
}

enum ServiceError: Error {
    case invalidURL
    case invalidResponse
    case decodingError(Error)
}


class FlickrService {
    
    private let baseURL = "https://www.flickr.com/services/feeds/photos_public.gne"
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }
    
   ///creates the full URL
    private func concatURL(with tag: String) -> URL? {
        
        var comps = URLComponents(string: baseURL)
        comps?.queryItems = [
            URLQueryItem(name: "format", value: "json"),
            URLQueryItem(name: "nojsoncallback", value: "1"),
            URLQueryItem(name: "tags", value: tag)
        ]
        return comps?.url
    }
}

extension FlickrService: ServiceProtocol {
   
    func fetchData(for tag: String) async throws -> [FlickrModel] {
        guard let url = concatURL(with: tag) else {
            throw ServiceError.invalidURL
        }
        
        let (data, response) = try await session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw ServiceError.invalidResponse
        }
        
        do {
            
            let decoder = JSONDecoder()
            let data = try decoder.decode(ServiceModel.self, from: data)
            return data.items
        }
        catch {
            throw ServiceError.decodingError(error)
        }
    }
}
