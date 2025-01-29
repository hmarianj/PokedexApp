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

struct Evolution: Codable {
    let chain: Chain
    
    struct Chain: Codable {
        let species: Pokemon
        let evolvesTo: [EvolvesTo]
    }
    
    struct EvolvesTo: Codable {
        let evolvesTo: [EvolvesTo]
        let species: Pokemon
    }
}

struct PokemonSpecies: Codable {
    let color: ApiColor
    let evolutionChain: EvolutionChain
    
    struct ApiColor: Codable {
        let name: BackgroundColor
    }
    
    struct EvolutionChain: Codable {
        let url: String
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


