//
//  EvolutionView.swift
//  PokedexApp
//
//  Created by MH on 15/01/2025.
//

import SwiftUI

struct EvolutionView: View {
    var model: EvolutionView.Model

    var body: some View {
        /// The evolution view is only shown if there are at least two elements
        if model.pokemons.count >= 2 {
            VStack {
                titleSection
                VStack {
                    ForEach(model.pokemons.indices, id: \.self) { index in
                        let evolution = model.pokemons[index]
                        card(for: evolution.pokemon)

                        if index < model.pokemons.count - 1 {
                            arrowLevel(for: evolution.evolutionMethod)
                        }
                    }
                }
                .padding(.vertical, 32)
                .padding(.horizontal, 18)
                .overlay {
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(.gray.opacity(0.4), lineWidth: 1)
                }
            }
        }
    }
}

extension EvolutionView {
    struct Model {
        let currentId: Int
        let pokemons: [EvolutionUIModel]
        let bgColor: Color
    }
}

private extension EvolutionView {
    @ViewBuilder
    func card(for pokemon: Pokemon) -> some View {
        if pokemon.id == model.currentId {
            ovalCard(for: pokemon)
        } else {
            NavigationLink {
                DetailsView(
                    model: .init(
                        id: pokemon.id,
                        title: pokemon.name,
                        imageUrl: pokemon.imageUrl
                    )
                )
            } label: {
                ovalCard(for: pokemon)
            }
        }
    }

    func ovalCard(for pokemon: Pokemon) -> some View {
        OvalCard(
            model: .init(
                titleName: pokemon.name,
                imageUrl: pokemon.imageUrl,
                id: pokemon.id,
                bgColor: model.bgColor
            )
        )
    }

    var titleSection: some View {
        Text("Evolution")
            .font(.system(.title2, weight: .bold))
            .padding(.vertical)
            .frame(maxWidth: .infinity, alignment: .leading)
    }

    func arrowLevel(for evolutionType: String?) -> some View {
        HStack {
            Spacer()
            Image(systemName: "arrowshape.down.fill")
                .font(.title2)
                .foregroundStyle(model.bgColor)

            Text(evolutionType ?? "")
            Spacer()
        }
        .padding(12)
    }
}

#Preview {
    EvolutionView(
        model: .init(
            currentId: 11,
            pokemons: [
                .init(
                    pokemon: .init(name: "Caterpee", url: "https://pokeapi.co/api/v2/pokemon-species/10/"),
                    evolvesTo: .init(name: "Metapod", url: "https://pokeapi.co/api/v2/pokemon-species/11/"),
                    level: 7,
                    evolutionMethod: ""
                ),
                .init(
                    pokemon: .init(name: "Metapod", url: "https://pokeapi.co/api/v2/pokemon-species/11/"),
                    evolvesTo: .init(name: "Butterfree", url: "https://pokeapi.co/api/v2/pokemon-species/12/"),
                    level: 10,
                    evolutionMethod: ""
                ),
                .init(
                    pokemon: .init(name: "Butterfree", url: "https://pokeapi.co/api/v2/pokemon-species/12/"),
                    evolvesTo: nil,
                    level: nil,
                    evolutionMethod: ""
                )
            ],
            bgColor: Color.bgBlue
        )
    )
    .padding()
}
