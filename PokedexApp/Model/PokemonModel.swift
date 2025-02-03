//
//  UserModel.swift
//  PokedexApp
//
//  Created by MH on 24/01/2025.
//

struct PokemonListResponse: Codable {
    let results: [Pokemon]
}

struct Pokemon: Codable {
    let name: String
    let url: String
    
    var id: Int {
        Int(url.split(separator: "/").last ?? "0") ?? 0
    }
    
    var imageUrl: String {
        "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(id).png"
    }
}


struct PokemonSpecies: Codable {
    let evolutionChain: EvolutionChain
    let genderRate: Int
    let flavorTextEntries: [FlavorTextEntries]
    
    struct EvolutionChain: Codable {
        let url: String
    }
    
    struct FlavorTextEntries: Codable {
        let flavorText: String
        let language: Language
        
    }

    struct Language: Codable {
        let name: String
    }
}

struct PokemonDetails: Codable {
    let types: [Types]
    let height: Int
    let weight: Int
    
    struct Types: Codable {
        let type: TypeDetail
    }
    
    struct TypeDetail: Codable {
        let name: String
    }
}

struct TypeAPIResponse: Codable {
    let damageRelations: DamageRelations

    struct DamageRelations: Codable {
        let doubleDamageFrom: [DamageType]
        let halfDamageFrom: [DamageType]
    }

    struct DamageType: Codable {
        let name: String
    }
}
