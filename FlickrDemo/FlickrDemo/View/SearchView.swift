//
//  SearchView.swift
//  FlickrDemo
//
//  Created by uuser on 2/7/25.
//

import SwiftUI

struct FlickrSearchView: View {
    
    @ObservedObject private var vM = SearchViewModel()
    
    private let gridColumn = [
        
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    var body: some View {
        NavigationView {
            VStack {
                searchTextField
                
                if vM.isLoading {
                    progressView
                }
                else if vM.hasError {
                    errorView
                }
                else {
                    imageListView
                }
                Spacer()
            }
            .navigationTitle("Flickr Demo").bold()
        }
    }
}

private extension FlickrSearchView {
    var searchTextField: some View {
        TextField("Search", text: $vM.searchString)
        
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding(.horizontal)
    }
    
    var progressView: some View {
        ProgressView("Loading")
            .padding()
    }
    
    var imageListView: some View {
        ScrollView {
            LazyVGrid(columns: gridColumn, spacing: 18) {
                ForEach(vM.flickrModelArray) { flickrImage in
                    NavigationLink {
                        DetailView(vM: DetailViewModel(selectedImage: flickrImage), entry: $vM.cache[flickrImage.id.uuidString])
                    } label: {
                        if let entry = vM.cache[flickrImage.id.uuidString], case .ready(let image) = entry {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .cornerRadius(8)
                        } else {
                            ProgressView()
                        }
                    }
                    .onAppear {
                        Task {
                            try await vM.loadImage(for: flickrImage)
                        }
                    }
                }
                .padding(.horizontal, 6)
            }
        }
    }
    
    var errorView: some View {
        Text("Error: \(vM.errorMsg)")
            .padding()
    }
}

#Preview {
    FlickrSearchView()
}
