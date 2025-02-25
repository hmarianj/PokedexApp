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
                ErrorView {
                    Task {
                        await viewModel.getPokemons()
                    }
                }
            } else if !viewModel.pokemons.isEmpty {
                contentView(viewModel.pokemons)
            } else {
                Text("Initial State")
            }
        }
        .task {
            await viewModel.getPokemons()
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

    func contentView(_: [Pokemon]) -> some View {
        NavigationStack {
            ScrollView {
                SearchBox(searchText: $searchText)
                    .padding(.bottom)
                    .padding(.horizontal)
                LazyVGrid(columns: adaptiveColumn, spacing: 20) {
                    ForEach(filteredPokemons, id: \.name) { item in
                        NavigationLink(
                            destination: DetailsView(
                                model: .init(
                                    id: item.id,
                                    title: item.name,
                                    imageUrl: item.imageUrl
                                )
                            )
                        ) {
                            CardView(
                                model: .init(
                                    imageUrl: item.imageUrl,
                                    name: item.name,
                                    id: item.id
                                )
                            )
                        }
                    }
                    .navigationTitle("Pokedex")
                }
                .padding()
            }
            .scrollIndicators(.hidden)
        }
    }
}

#Preview {
    HomeView()
}
