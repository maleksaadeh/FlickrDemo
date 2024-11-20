//
//  FlickrFeedViewModel.swift
//  FlickrDemo
//
//  Created by Malek Saadeh on 11/19/24.
//

import Foundation
import Combine

enum ViewState {
    case loading
    case loaded
    case error
    case noActions
}

class FlickrFeedViewModel: ObservableObject {
    private let service: any NetworkService
    private var cancellables = Set<AnyCancellable>()
    private var inputTimer: Timer?
    
    @Published var flickrImages: [FlickrImage] = []
    @Published var viewState: ViewState = .noActions
    
    init(service: FlickrNetworkService) {
        self.service = service
    }
    
    func fetchFlickrImages(_ searchQuery: String) {
        guard !searchQuery.isEmpty else {
            flickrImages = []
            return
        }
        viewState = .loading
        updateTimer(searchQuery)
    }
    
    private func updateTimer(_ searchQuery: String) {
        inputTimer?.invalidate()
        inputTimer = nil
        inputTimer = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { [weak self] _ in
            self?.fetchService(searchQuery)
        }
    }
    
    private func fetchService(_ searchQuery: String) {
        service.fetch(for: Environment.search(searchQuery).request)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error):
                    print(error)
                    self?.viewState = .error
                case .finished:
                    print("Data finished fetching")
                    self?.viewState = .loaded
                }
            } receiveValue: { [weak self] (response: FlickrFeedResponse) in
                self?.flickrImages = response.items
            }
            .store(in: &cancellables)
    }
}
