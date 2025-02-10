//
//  DetailView.swift
//  FlickrDemo
//
//  Created by uuser on 2/7/25.
//

import SwiftUI

struct DetailView: View {
    
    let vM: DetailViewModel
    @Binding var entry: SearchViewModel.CacheEntry?
    @State private var sharePresented = false
    
    var body: some View {
        VStack(alignment: .center, spacing: 12) {
            if let entry = entry, case .ready(let image) = entry {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(8)
            }
            else {
                ProgressView()
            }
            
            Text(vM.title)
                .font(.title)
            
            if let nsAttributedString = try? NSAttributedString(data: Data(vM.title.utf8), options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil),
               let attributedString = try? AttributedString(nsAttributedString, including: \.uiKit) {
                Text(attributedString)
            } else {
                Text(vM.title)
            }
            
            Text(vM.author)
                .font(.subheadline)
            
            Text(vM.publishedDate)
                .font(.body)
            
        }
        .padding(.horizontal, 6)
        
        ///share details button
        Button(action: {sharePresented = true }) {
            Label("Share Details", systemImage: "square.and.arrow.up.fill")
                .frame(maxWidth: .infinity)
        }
        .padding()
        //TODO: add this sheet
//        .sheet(isPresented: $sharePresented) {
//    
//        }
    }
}

//helper for share details
struct ActivityViewContrller: UIViewControllerRepresentable {
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
