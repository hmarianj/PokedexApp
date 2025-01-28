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
    func contentView(_ pokemons: [Pokemon]) -> some View {
        NavigationStack {
            ScrollView {
                SearchBox(searchText: .constant(""))
                    .padding(.bottom)
                LazyVGrid(columns: adaptiveColumn, spacing: 20) {
                    ForEach(viewModel.pokemons, id: \.name) { item in
                        NavigationLink(
                            destination: DetailsView(
                                id: item.id,
                                title: item.name, // TODO: pasa valor real
                                description: item.name, // TODO: pasa valor real
                                number: item.name,
                                imageUrl: item.imageUrl // TODO: parametrizar
                            )
                        ) {
                            CardView(imageUrl: item.imageUrl, name: item.name)
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
