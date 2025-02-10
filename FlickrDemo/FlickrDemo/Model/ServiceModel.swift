//
//  ServiceModel.swift
//  FlickrDemo
//
//  Created by uuser on 2/7/25.
//

import Foundation

struct ServiceModel: Decodable {
   
    let title: String
    let link: String
    let description: String
    let modified: String
    let generator: String
    let items: [FlickrModel]
    
}

