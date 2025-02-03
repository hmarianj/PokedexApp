//
//  EvolutionView.swift
//  PokedexApp
//
//  Created by MH on 15/01/2025.
//

import SwiftUI

struct EvolutionView: View {
    
    let pokemons: [Pokemon]
    let bgColor: Color

    var body: some View {
        /// The evolution view is only shown if there are at least two elements
        if pokemons.count >= 2 {
            VStack {
                titleSection
                VStack {
                    ForEach(pokemons, id: \.id) { pokemon in
                        OvalCard(
                            titleName: pokemon.name,
                            imageUrl: pokemon.imageUrl,
                            numberID: pokemon.id,
                            bgColor: bgColor
                        )
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
                    .foregroundStyle(.blue)
                Spacer()
            }
            .padding(12)
        }
}

#Preview {
    EvolutionView(pokemons: [
        .init(name: "Metapod", url: "https://pokeapi.co/api/v2/pokemon-species/11/"),
        .init(name: "Butterfree", url: "https://pokeapi.co/api/v2/pokemon-species/12/")
    ], bgColor: Color.bgBlue)
        .padding()
}
