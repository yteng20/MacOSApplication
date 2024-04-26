//
//  SearchBar.swift
//  FitnessTracker
//
//  Created by Yue Teng on 4/24/24.
//

import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    let onSearch: () -> Void

    var body: some View {
        HStack {
            TextField("Search", text: $text)
                .padding()
                .frame(width: 150)

            Button("Search") {
                onSearch()
            }
            .padding()
            .frame(minWidth: 100)
        }
        .padding()
    }
}
