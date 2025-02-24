//
//  EvolutionView.swift
//  PokedexApp
//
//  Created by MH on 15/01/2025.
//

import SwiftUI

struct EvolutionView: View {
    let currentId: Int
    let pokemons: [Pokemon]
    let bgColor: Color

    var body: some View {
        /// The evolution view is only shown if there are at least two elements
        if pokemons.count >= 2 {
            VStack {
                titleSection
                VStack {
                    ForEach(pokemons, id: \.id) { pokemon in
                        card(for: pokemon)
                        if pokemons.last?.id != pokemon.id {
                            arrowLevel
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

private extension EvolutionView {
    @ViewBuilder
    func card(for pokemon: Pokemon) -> some View {
        if pokemon.id == currentId {
            ovalCard(for: pokemon)
        } else {
            NavigationLink {
                DetailsView(
                    id: pokemon.id,
                    title: pokemon.name,
                    imageUrl: pokemon.imageUrl
                )
            } label: {
                ovalCard(for: pokemon)
            }
        }
    }

    func ovalCard(for pokemon: Pokemon) -> some View {
        OvalCard(
            titleName: pokemon.name,
            imageUrl: pokemon.imageUrl,
            id: pokemon.id,
            bgColor: bgColor
        )
    }

    var titleSection: some View {
        Text("Evolution")
            .font(.system(.title2, weight: .bold))
            .padding(.vertical)
            .frame(maxWidth: .infinity, alignment: .leading)
    }

    var arrowLevel: some View {
        HStack {
            Spacer()
            Image(systemName: "arrowshape.down.fill")
                .font(.title2)
                .foregroundStyle(bgColor)
            Spacer()
        }
        .padding(12)
    }
}

#Preview {
    EvolutionView(
        currentId: 11,
        pokemons: [
            .init(name: "Metapod", url: "https://pokeapi.co/api/v2/pokemon-species/11/"),
            .init(name: "Butterfree", url: "https://pokeapi.co/api/v2/pokemon-species/12/")
        ],
        bgColor: Color.bgBlue
    )
    .padding()
}
