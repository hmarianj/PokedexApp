//
//  ServiceMocks.swift
//  PokedexApp
//
//  Created by MH on 21/02/2025.
//

import Foundation

struct ServiceMocks: PokemonServiceProtocol {
    
    func getPokemonSpeciesData(id: Int) async throws -> PokemonSpecies {
        return PokemonSpecies(
            evolutionChain: .init(url: ""),
            genderRate: 2,
            flavorTextEntries: []
        )
    }
    
    func getPokemonDetailsData(id: Int) async throws -> PokemonDetails {
        return PokemonDetails(
            types: [PokemonDetails.Types].init(),
            height: 12,
            weight: 12
        )
    }
    
    func getPokemonsEvolutionData(url: String) async throws -> [Pokemon] {
        return [Pokemon.init(name: "charmander", url: "https://pokeapi.co/api/v2/pokemon/4/")]
    }
    
    func getTypeWeaknesses(for typeName: String) async throws -> TypeAPIResponse {
        if typeName == "fire" {
            return TypeAPIResponse(
                damageRelations: TypeAPIResponse.DamageRelations(
                    doubleDamageFrom: [TypeAPIResponse.DamageType(name: "water")],
                    halfDamageFrom: [TypeAPIResponse.DamageType(name: "grass")]
                )
            )
        }
        return TypeAPIResponse(
            damageRelations: TypeAPIResponse.DamageRelations(
                doubleDamageFrom: [],
                halfDamageFrom: []
            )
        )
    }
}
