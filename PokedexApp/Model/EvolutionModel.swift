//
//  EvolutionModel.swift
//  PokedexApp
//
//  Created by MH on 03/02/2025.
//

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

extension Evolution {
    var pokemons: [Pokemon] {
        chain.allEvolvedPokemons()
    }
}

extension Evolution.Chain {
    func allEvolvedPokemons() -> [Pokemon] {
        var result: [Pokemon] = []
        result.append(species)
        for evolution in evolvesTo {
            result.append(evolution.species)
            result.append(contentsOf: evolution.allEvolvedPokemons())
        }
        return result
    }
}

extension Evolution.EvolvesTo {
    func allEvolvedPokemons() -> [Pokemon] {
        var result: [Pokemon] = []
        for evolution in evolvesTo {
            result.append(evolution.species)
            result.append(contentsOf: evolution.allEvolvedPokemons())
        }
        return result
    }
}
