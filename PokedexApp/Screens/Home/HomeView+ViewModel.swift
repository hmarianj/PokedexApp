//
//  HomeView+ViewModel.swift
//  PokedexApp
//
//  Created by MH on 24/01/2025.
//

import CoreNetworking
import Foundation

extension HomeView {
    class ViewModel: ObservableObject {
        @Published var pokemons: [Pokemon] = []
        @Published var pokemonDetails: PokemonDetails? = nil
        @Published var isLoading: Bool = false
        @Published var displayError: Bool = false
    }
}

extension HomeView.ViewModel {
    @MainActor
    func getPokemons() async {
        isLoading = true
        displayError = false
        do {
            let response = try await HTTPClient.shared.execute(
                Request(
                    urlString: "https://pokeapi.co/api/v2/pokemon",
                    method: .get([.init(name: "limit", value: "151")])
                ),
                responseType: PokemonListResponse.self
            )
            isLoading = false
            pokemons = response.results
        } catch {
            isLoading = false
            displayError = true
        }
    }
}
