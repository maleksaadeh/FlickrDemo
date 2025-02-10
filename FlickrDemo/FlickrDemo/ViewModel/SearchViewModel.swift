//
//  DetailViewModel.swift
//  FlickrDemo
//
//  Created by uuser on 2/7/25.
//

import Foundation
import Combine
import SwiftUI

@MainActor
class SearchViewModel: ObservableObject {
    
    enum CacheEntry {
        case inProgress(Task<UIImage, Error>)
        case ready(UIImage)
    }
    
    @Published var cache: [String: CacheEntry] = [:]
    @Published var isLoading = false
    @Published var hasError = false
    @Published var errorMsg = ""
    @Published var searchString: String = ""
    
    var flickrModelArray: [FlickrModel] = []

    private var cancellables = Set<AnyCancellable>()
    let flickrService: FlickrService
    private var prevSearch: String?

    init(flickrService: FlickrService = FlickrService()) {
        self.flickrService = flickrService
        
        $searchString
            .debounce(for: .milliseconds(250), scheduler: DispatchQueue.main)
            .sink { [weak self] searchedString in
                if searchedString == self?.prevSearch { return }
                self?.prevSearch = searchedString
                self?.performSearch(searchedString: searchedString)
            }
            .store(in: &cancellables)
    }

    private func performSearch(searchedString: String) {
        guard !searchedString.isEmpty else {
            flickrModelArray = []
            return
        }

        isLoading = true
        hasError = false

        Task {
            do {
                let items = try await flickrService.fetchData(for: searchedString)
                self.isLoading = false
                self.flickrModelArray = items
            } catch {
                self.isLoading = false
                self.hasError = true
                self.errorMsg = error.localizedDescription
            }
        }
    }
    
    func loadImage(for item: FlickrModel) async throws -> UIImage {
        
        ///Testing purpooses:
        ///print("\(item.id.uuidString)")
        if let cached = cache[item.id.uuidString] {
            switch cached {
            case .ready(let image):
                return image
            case .inProgress(let task):
                Task {
                    return try await task.value
                }
            }
        }
        
        let task = Task {
            try await downloadImage(for: item)
        }
        
        cache[item.id.uuidString] = .inProgress(task)

        let image = try await task.value
        cache[item.id.uuidString] = .ready(image)
        
        return image
    }
    
    /// helper method for load image basically
    private func downloadImage(for item: FlickrModel) async throws -> UIImage {
        guard let url = URL(string: item.media.m) else { return UIImage(systemName: "photo")! }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let image = UIImage(data: data) else { return UIImage(systemName: "photo")! }
            return image
        }
        catch {
            return UIImage(systemName: "photo")!
        }
    }
}
