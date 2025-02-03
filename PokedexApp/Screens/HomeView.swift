//
//  HomeView.swift
//  PokedexApp
//
//  Created by MH on 06/01/2025.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject private var viewModel: ViewModel = ViewModel()
    
    private let adaptiveColumn = [
        GridItem(.adaptive(minimum: 150))
    ]
    
    @State var searchText: String = ""
    
    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView()
            } else if viewModel.displayError {
                Text("Create screen error") // TODO: create an Error View
            } else if !viewModel.pokemons.isEmpty {
                contentView(viewModel.pokemons)
            } else {
                Text("Initial State")
            }
        }
        .task {
            await viewModel.getUser()
        }
    }
}

private extension HomeView {
    
    var filteredPokemons: [Pokemon] {
        if searchText.isEmpty {
            return viewModel.pokemons
        } else {
            return viewModel.pokemons.filter {
                $0.name.lowercased().contains(searchText.lowercased())
            }
        }
    }
    
    func contentView(_ pokemons: [Pokemon]) -> some View {
        NavigationStack {
            ScrollView {
                SearchBox(searchText: $searchText)
                    .padding(.bottom)
                LazyVGrid(columns: adaptiveColumn, spacing: 20) {
                    ForEach(filteredPokemons, id: \.name) { item in
                        NavigationLink(
                            destination: DetailsView(
                                id: item.id,
                                title: item.name,
                                imageUrl: item.imageUrl
                            )
                        ) {
                            CardView(
                                imageUrl: item.imageUrl,
                                name: item.name,
                                id: item.id
                            )
                        }
                    }
                    .navigationTitle("Pokedex")
                }
            }
            .scrollIndicators(.hidden)
            .padding()
        }
    }
}

#Preview {
    HomeView()
}
