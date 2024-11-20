//
//  NetworkError.swift
//  FlickrDemo
//
//  Created by Malek Saadeh on 11/19/24.
//

import Foundation

enum NetworkError: Error {
    case failedToCreateRequest
    case decodeError(DecodingError)
    case serverError(Error)
}
