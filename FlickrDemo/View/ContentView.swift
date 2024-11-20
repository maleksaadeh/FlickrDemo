//
//  ContentView.swift
//  FlickrDemo
//
//  Created by Malek Saadeh on 11/19/24.

import Foundation
import SwiftUI

// Image Caching

struct ContentView: View {
    @State private var searchText = ""
    @StateObject var viewmodel: FlickrFeedViewModel = FlickrFeedViewModel(service: FlickrNetworkService())
    
    var body: some View {
        NavigationStack {
            VStack {
                SearchBar(text: $searchText)
                    .onChange(of: searchText) { _ in
                        searchImages()
                    }
                
                switch viewmodel.viewState {
                case .loading:
                    ProgressView()
                case .loaded:
                    ScrollView {
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: 8) {
                            ForEach(viewmodel.flickrImages) { image in
                                NavigationLink(
                                    destination: ImageDetailView(image: image)
                                ) {
                                    AsyncImage(url: image.thumbnailURL) { phase in
                                        switch phase {
                                        case .success(let image):
                                            image.resizable().aspectRatio(contentMode: .fill)
                                        case .failure:
                                            Color.gray
                                        case .empty:
                                            ProgressView()
                                        @unknown default:
                                            fatalError()
                                        }
                                    }
                                    .frame(width: 110, height: 110)
                                    .cornerRadius(8)
                                }
                            }
                        }
                        .padding()
                    }
                case .error:
                    VStack {
                        Spacer()
                        Text("Oops, something went wrong")
                        Button("Try Again") {
                            searchImages()
                        }
                        Spacer()
                    }
                default:
                    EmptyView()
                }
                Spacer()
            }
            .navigationTitle("Flickr CVS Demo")
            .font(.largeTitle)
        }
    }
    
    private func searchImages() {
        viewmodel.fetchFlickrImages(searchText)
    }
}
