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
        @Published var evolutionPokemons: [Pokemon] = []
        @Published var weaknesses: [String] = []
        
        init() {
            let jsonDecoder = JSONDecoder()
            jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
            HTTPClient.shared.jsonDecoder = jsonDecoder
        }
                
        var maleFraction: CGFloat {
            guard let genderRate = pokemonSpecies?.genderRate, genderRate != -1 else { return 0 }
            return CGFloat(1 - (Double(genderRate) / 8.0))
        }
        
        var pokemonDescription: String {
            guard let entries = pokemonSpecies?.flavorTextEntries else { return "Descripción no disponible" }
            
            let rawText = entries.first(where: { $0.language.name == "en" })?.flavorText.replacingOccurrences(of: "\n", with: " ") ?? "Descripción no disponible"
            
            return rawText
                .replacingOccurrences(of: "POKéMON", with: "Pokémon")
                .replacingOccurrences(of: "POKEMON", with: "Pokémon")
        }
        
        func loadPokemonSpeciesData(id: Int) async {
            isLoading = true
            do {
                let response = try await HTTPClient.shared.execute(
                    Request(
                        urlString: "https://pokeapi.co/api/v2/pokemon-species/\(id)",
                        method: .get([])
                    ),
                    responseType: PokemonSpecies.self
                )
                self.pokemonSpecies = response
                await loadEvolutions(url: response.evolutionChain.url)
            } catch {
                isLoading = false
                displayError = true
            }
        }
        
        func loadPokemonDetails(id: Int) async {
            isLoading = true
            do {
                let response = try await HTTPClient.shared.execute(
                    Request(
                        urlString: "https://pokeapi.co/api/v2/pokemon/\(id)",
                        method: .get([])
                    ),
                    responseType: PokemonDetails.self
                )
                self.pokemonDetails = response
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
                let response = try await HTTPClient.shared.execute(
                    Request(
                        urlString: url,
                        method: .get([])
                    ),
                    responseType: Evolution.self
                )
                isLoading = false
                self.evolutionPokemons = response.pokemons
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
                let typeURL = "https://pokeapi.co/api/v2/type/\(typeName)/"
                
                do {
                    let response = try await HTTPClient.shared.execute(
                        Request(
                            urlString: typeURL,
                            method: .get([])
                        ),
                        responseType: TypeAPIResponse.self
                    )
                    
                    let weaknesses = response.damageRelations.doubleDamageFrom.map { $0.name }
                    let resistances = response.damageRelations.halfDamageFrom.map { $0.name }
                    allWeaknesses.formUnion(weaknesses)
                    allResistances.formUnion(resistances)
                    allWeaknesses.subtract(allResistances)
                } catch {
                    isLoading = false
                    // TODO: error view
                }
            }
            
            isLoading = false
            self.weaknesses = Array(allWeaknesses)
        }
    }
}
