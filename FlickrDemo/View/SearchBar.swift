//
//  SearchBar.swift
//  FlickrDemo
//
//  Created by Malek Saadeh on 11/19/24.
//

import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
            TextField("Search images", text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }
        .padding()
    }
}
