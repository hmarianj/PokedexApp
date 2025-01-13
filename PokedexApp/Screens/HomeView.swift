//
//  HomeView.swift
//  PokedexApp
//
//  Created by MH on 06/01/2025.
//

import SwiftUI

struct HomeView: View {
    
    let items = [
        ("Card 1", "This is the first card."),
        ("Card 2", "This is the second card."),
        ("Card 3", "This is the third card."),
        ("Card 4", "This is the third card."),
        ("Card 5", "This is the first card."),
        ("Card 6", "This is the second card."),
        ("Card 7", "This is the third card."),
        ("Card 8", "This is the third card.")
    ]
    
    private let adaptiveColumn = [
        GridItem(.adaptive(minimum: 150))
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: adaptiveColumn, spacing: 20) {
                    ForEach(items, id: \.0) { item in
                        NavigationLink(destination: DetailsView(title: item.0, description: item.1)) {
                            CardView()
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    HomeView()
        .padding()
}
