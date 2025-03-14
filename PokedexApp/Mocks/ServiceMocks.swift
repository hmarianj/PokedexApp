//
//  ServiceMocks.swift
//  PokedexApp
//
//  Created by MH on 21/02/2025.
//

import Foundation

struct ServiceMocks: PokemonServiceProtocol {
    var shouldFail: Bool = false

    init(shouldFail: Bool) {
        self.shouldFail = shouldFail
    }

    func getPokemonSpeciesData(id _: Int) async throws -> PokemonSpecies {
        if shouldFail {
            throw NSError(domain: "", code: 1)
        }
        return PokemonSpecies(
            evolutionChain: .init(url: ""),
            genderRate: 2,
            flavorTextEntries: []
        )
    }

    func getPokemonDetailsData(id _: Int) async throws -> PokemonDetails {
        PokemonDetails(
            types: [PokemonDetails.Types](),
            height: 12,
            weight: 12
        )
    }

    func getPokemonsEvolutionData(url _: String) async throws -> [EvolutionUIModel] {
        [
            .init(
                pokemon: .init(name: "Metapod", url: "https://pokeapi.co/api/v2/pokemon-species/11/"),
                evolvesTo: .init(name: "Butterfree", url: "https://pokeapi.co/api/v2/pokemon-species/12/"),
                level: 10,
                evolutionMethod: ""
            )
        ]
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
