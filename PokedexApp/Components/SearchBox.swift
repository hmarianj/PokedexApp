//
//  SearchBox.swift
//  PokedexApp
//
//  Created by MH on 13/01/2025.
//

import SwiftUI

struct SearchBox: View {
    
    @Binding var searchText: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .font(.title3)
                .foregroundStyle(.gray)
            TextField(
                "",
                text: $searchText,
                prompt: Text("Search pokemon, ability...")
            )
            .font(.body)
            .foregroundStyle(searchText.isEmpty ? .gray : .black)
        }
        .padding(12)
        .overlay {
            RoundedRectangle(cornerRadius: 16)
                .stroke(.clear)
                .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 6)
        }
        .background(.gray.opacity(0.1))
        .cornerRadius(16)
        }
    }


#Preview {
    SearchBox(searchText: .constant(""))
}
