//
//  FlickrNetworkService.swift
//  FlickrDemo
//
//  Created by Malek Saadeh on 11/19/24.
//

import Foundation
import Combine

protocol NetworkService {
    func fetch<Model: Decodable>(for request: URLRequest?) -> AnyPublisher<Model, NetworkError>
}

class FlickrNetworkService: NetworkService {
    func fetch<Model: Decodable>(for request: URLRequest?) -> AnyPublisher<Model, NetworkError> {
        guard let request else {
            return Fail(error: NetworkError.failedToCreateRequest)
                .eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .map { $0.data }
            .decode(type: Model.self, decoder: JSONDecoder())
            .mapError { error in
                if let decodingError = error as? DecodingError {
                    return NetworkError.decodeError(decodingError)
                }
                return NetworkError.serverError(error)
            }
            .eraseToAnyPublisher()
    }
}
