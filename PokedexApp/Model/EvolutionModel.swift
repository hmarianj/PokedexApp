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
        let evolvesTo: [EvolvesTo]?
    }

    struct EvolvesTo: Codable {
        let evolvesTo: [EvolvesTo]?
        let species: Pokemon
        let evolutionDetails: [EvolutionDetail]?
    }

    struct EvolutionDetail: Codable {
        let minLevel: Int?
        let trigger: EvolutionTrigger
    }

    struct EvolutionTrigger: Codable {
        let name: String
    }
}

struct EvolutionUIModel: Identifiable {
    var id: Int {
        pokemon.id
    }

    let pokemon: Pokemon
    let evolvesTo: Pokemon?
    let level: Int?
    let evolutionMethod: String?
}

extension Evolution {
    var pokemons: [EvolutionUIModel] {
        chain.allEvolvedPokemons()
    }
}

extension Evolution.Chain {
    func allEvolvedPokemons() -> [EvolutionUIModel] {
        var result: [EvolutionUIModel] = []

        if let evolvesTo {
            for evolution in evolvesTo {
                let level = evolution.evolutionDetails?.first?.minLevel
                let evolutionMethod = evolution.evolutionDetails?.first?.trigger.name ?? "Unknown Method"

                result.append(EvolutionUIModel(
                    pokemon: species,
                    evolvesTo: evolution.species,
                    level: level,
                    evolutionMethod: level != nil ? "Level \(level!)" : evolutionMethod.capitalized
                ))

                result.append(contentsOf: evolution.allEvolvedPokemons())
            }
        }

        if evolvesTo?.isEmpty ?? true {
            result.append(EvolutionUIModel(pokemon: species, evolvesTo: nil, level: nil, evolutionMethod: nil))
        }

        return result
    }
}

extension Evolution.EvolvesTo {
    func allEvolvedPokemons() -> [EvolutionUIModel] {
        var result: [EvolutionUIModel] = []

        if let evolvesTo {
            for evolution in evolvesTo {
                let level = evolution.evolutionDetails?.first?.minLevel
                let evolutionMethod = evolution.evolutionDetails?.first?.trigger.name ?? "Unknown Method"

                result.append(EvolutionUIModel(
                    pokemon: species,
                    evolvesTo: evolution.species,
                    level: level,
                    evolutionMethod: level != nil ? "Level \(level!)" : evolutionMethod.capitalized
                ))

                result.append(contentsOf: evolution.allEvolvedPokemons())
            }
        }

        if evolvesTo?.isEmpty ?? true {
            result.append(EvolutionUIModel(pokemon: species, evolvesTo: nil, level: nil, evolutionMethod: nil))
        }

        return result
    }
}
