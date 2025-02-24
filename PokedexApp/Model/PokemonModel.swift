//
//  UserModel.swift
//  PokedexApp
//
//  Created by MH on 24/01/2025.
//

import Foundation

struct PokemonListResponse: Codable {
    let results: [Pokemon]
}

struct Pokemon: Codable, Identifiable {
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

/// Helpers to add arrays to AppStorage
extension Array: @retroactive RawRepresentable where Element: Codable {
    
    public init?(rawValue: String) {
        guard
            let data = rawValue.data(using: .utf8),
            let result = try? JSONDecoder().decode([Element].self, from: data)
        else { return nil }
        self = result
    }
    
    public var rawValue: String {
        guard
            let data = try? JSONEncoder().encode(self),
            let result = String(data: data, encoding: .utf8)
        else { return "" }
        return result
    }
}

extension Dictionary: @retroactive RawRepresentable where Key: Codable, Value: Codable {
    
    public init?(rawValue: String) {
        guard
            let data = rawValue.data(using: .utf8),
            let result = try? JSONDecoder().decode([Key: Value].self, from: data)
        else { return nil }
        self = result
    }
    
    public var rawValue: String {
        guard
            let data = try? JSONEncoder().encode(self),
            let result = String(data: data, encoding: .utf8)
        else { return "{}" }
        return result
    }
}
