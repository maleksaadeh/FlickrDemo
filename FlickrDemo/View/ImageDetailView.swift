//
//  ImageDetailView.swift
//  FlickrDemo
//
//  Created by Malek Saadeh on 11/19/24.
//

import SwiftUI

struct ImageDetailView: View {
    let image: FlickrImage
    @State private var sharePresented = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                AsyncImage(url: image.largeImageURL) { phase in
                    switch phase {
                    case .success(let image):
                        image.resizable().aspectRatio(contentMode: .fit)
                            .transition(.slide)
                    case .failure:
                        Color.gray
                    case .empty:
                        ProgressView()
                    @unknown default:
                        fatalError()
                    }
                }
                .frame(maxWidth: .infinity)
                .animation(.easeInOut, value: image.largeImageURL)
                
                Group {
                    
                    Text("Title").font(.headline)
                    Text(image.title).font(.body)
                    
                    Text("Description").font(.headline)
                    Text(image.description.htmlStripped).font(.body)
                    
                    Text("Author").font(.headline)
                    Text(image.author).font(.body)
                    
                    Text("Published").font(.headline)
                    Text(formatDate(image.published)).font(.body)
                    
                    // dimensions, but need to get dimensions from the description
                    if let dimensions = image.imageDimensions {
                        Text("Dimensions").font(.headline)
                        Text("\(dimensions.width) x \(dimensions.height)").font(.body)
                    }
                }
                .padding(.horizontal)
                
                //share details button
                Button(action: { sharePresented = true }) {
                    Label("Share Details", systemImage: "square.and.arrow.up.fill")
                        .frame(maxWidth: .infinity)
                }
                .padding()
            }
        }
        .navigationTitle("Image Details")
        // added share details
        .sheet(isPresented: $sharePresented) {
            ActivityViewController(items: [image.largeImageURL as Any, image.title])
        }
    }
    
    
    private func formatDate(_ dateString: String) -> String {
        let formatter = ISO8601DateFormatter()
        if let date = formatter.date(from: dateString) {
            let displayFormatter = DateFormatter()
            displayFormatter.dateStyle = .medium
            displayFormatter.timeStyle = .short
            return displayFormatter.string(from: date)
        }
        return dateString
    }
}

/// share helper struct
struct ActivityViewController: UIViewControllerRepresentable {
    let items: [Any]
    let applicationActivities: [UIActivity]? = nil
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(
            activityItems: items,
            applicationActivities: applicationActivities
        )
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
