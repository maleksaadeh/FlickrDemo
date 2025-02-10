//
//  DetailViewModel.swift
//  FlickrDemo
//
//  Created by uuser on 2/7/25.
//

import Foundation
import SwiftUI

struct DetailViewModel {
    
    let selectedImage: FlickrModel

    var title: String {
        selectedImage.title
    }
    
    var description: String {
        selectedImage.description
    }
    
    var author: String {
        "Author: \(selectedImage.author)"
    }
    
    var largeImageURL: URL? {
        return URL(string: selectedImage.link.replacingOccurrences(of: "_m", with: ""))
    }
    
    var publishedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        if let date = formatter.date(from: selectedImage.published) {
            return "Published: \(date)"
        }
        
        return "No Date Available"
    }
}
