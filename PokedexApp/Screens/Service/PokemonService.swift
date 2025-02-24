//
//  PokemonService.swift
//  PokedexApp
//
//  Created by MH on 21/02/2025.
//

import CoreNetworking
import Foundation

protocol PokemonServiceProtocol {
    func getPokemonSpeciesData(id: Int) async throws -> PokemonSpecies
    func getPokemonDetailsData(id: Int) async throws -> PokemonDetails
    func getPokemonsEvolutionData(url: String) async throws -> [Pokemon]
    func getTypeWeaknesses(for typeName: String) async throws -> TypeAPIResponse
}

struct PokemonService: PokemonServiceProtocol {
    
    init() {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        HTTPClient.shared.jsonDecoder = jsonDecoder
    }
    
    func getPokemonSpeciesData(id: Int) async throws -> PokemonSpecies {
        try await HTTPClient.shared.execute(
            Request(
                urlString: "https://pokeapi.co/api/v2/pokemon-species/\(id)",
                method: .get([])
            ),
            responseType: PokemonSpecies.self
        )
    }
    
    func getPokemonDetailsData(id: Int) async throws -> PokemonDetails {
        try await HTTPClient.shared.execute(
            Request(
                urlString: "https://pokeapi.co/api/v2/pokemon/\(id)",
                method: .get([])
            ),
            responseType: PokemonDetails.self
        )
    }
    
    func getPokemonsEvolutionData(url: String) async throws -> [Pokemon] {
        let response = try await HTTPClient.shared.execute(
            Request(
                urlString: url,
                method: .get([])
            ),
            responseType: Evolution.self
        )
        return response.pokemons
    }
    
    func getTypeWeaknesses(for typeName: String) async throws -> TypeAPIResponse {
        try await HTTPClient.shared.execute(
            Request(
                urlString: "https://pokeapi.co/api/v2/type/\(typeName)/",
                method: .get([])
            ),
            responseType: TypeAPIResponse.self
        )
    }
}
