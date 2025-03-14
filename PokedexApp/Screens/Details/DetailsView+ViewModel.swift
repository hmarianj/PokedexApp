//
//  DetailsView+ViewModel.swift
//  PokedexApp
//
//  Created by MH on 03/02/2025.
//

import CoreNetworking
import Foundation
import SwiftUI

extension DetailsView {
    @MainActor
    class ViewModel: ObservableObject {
        @Published var isLoading: Bool = false
        @Published var displayError: Bool = false
        @Published var pokemonSpecies: PokemonSpecies? = nil
        @Published var pokemonDetails: PokemonDetails? = nil
        @Published var evolutionPokemons: [EvolutionUIModel] = []

        @Published var weaknesses: [String] = []
        private let pokemonService: PokemonServiceProtocol

        init(pokemonService: PokemonServiceProtocol = PokemonService()) {
            self.pokemonService = pokemonService
        }

        var maleFraction: CGFloat {
            guard let genderRate = pokemonSpecies?.genderRate, genderRate != -1 else { return 0 }
            return CGFloat(1 - (Double(genderRate) / 8.0))
        }

        var pokemonDescription: String {
            guard let entries = pokemonSpecies?.flavorTextEntries else { return "Description not available" }

            let rawText = entries.first(where: { $0.language.name == "en" })?.flavorText
                .replacingOccurrences(of: "\n", with: " ") ?? "Description not available"

            return rawText
                .replacingOccurrences(of: "POKéMON", with: "Pokémon")
                .replacingOccurrences(of: "POKEMON", with: "Pokémon")
        }

        func loadPokemonSpeciesData(id: Int) async {
            isLoading = true
            do {
                let response = try await pokemonService.getPokemonSpeciesData(id: id)
                pokemonSpecies = response
                await loadEvolutions(url: response.evolutionChain.url)
            } catch {
                isLoading = false
                displayError = true
            }
        }

        func loadPokemonDetails(id: Int) async {
            isLoading = true
            do {
                let response = try await pokemonService.getPokemonDetailsData(id: id)
                pokemonDetails = response
                await loadWeaknesses(types: response.types)

            } catch {
                isLoading = false
                print("Error al cargar los detalles del Pokémon")
            }
        }

        private func loadEvolutions(url: String) async {
            isLoading = true
            // Call evolution api
            do {
                let response = try await pokemonService.getPokemonsEvolutionData(url: url)
                isLoading = false
                evolutionPokemons = response
            } catch {
                isLoading = false
                // TODO: Error
                //                displayError = true
            }
        }

        func loadWeaknesses(types: [PokemonDetails.Types]) async {
            var allWeaknesses: Set<String> = []
            var allResistances: Set<String> = []

            for type in types {
                let typeName = type.type.name

                do {
                    let response = try await pokemonService.getTypeWeaknesses(for: typeName)
                    let weaknesses = response.damageRelations.doubleDamageFrom.map(\.name)
                    let resistances = response.damageRelations.halfDamageFrom.map(\.name)
                    allWeaknesses.formUnion(weaknesses)
                    allResistances.formUnion(resistances)
                    allWeaknesses.subtract(allResistances)
                } catch {
                    isLoading = false
                    // TODO: error view
                }
            }

            isLoading = false
            weaknesses = Array(allWeaknesses)
        }
    }
}
