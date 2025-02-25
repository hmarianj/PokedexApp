//
//  MyPokemons.swift
//  PokedexApp
//
//  Created by MH on 05/02/2025.
//
import Foundation
import SwiftUI

struct MyPokemons: View {
    @AppStorage(AppStorageKeys.myPokemons.rawValue) var myPokemons: [Pokemon] = []

    private let adaptiveColumn = [
        GridItem(.adaptive(minimum: 150))
    ]

    var body: some View {
        if myPokemons.isEmpty {
            emptyView
        } else {
            pokemonsCaught
        }
    }

    var pokemonsCaught: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: adaptiveColumn, spacing: 20) {
                    ForEach(myPokemons, id: \.name) { item in
                        NavigationLink(
                            destination: DetailsView(
                                model: .init(
                                    id: item.id,
                                    title: item.name,
                                    imageUrl: item.imageUrl
                                )
                            )
                        ) {
                            CardView(
                                model: .init(
                                    imageUrl: item.imageUrl,
                                    name: item.name,
                                    id: item.id
                                )
                            )
                        }
                    }
                    .navigationTitle("My pokemons")
                }
                .padding()
            }
            .scrollIndicators(.hidden)
        }
    }

    var emptyView: some View {
        VStack(spacing: 16) {
            Spacer()
            Image("pokeball-bg")
                .resizable()
                .renderingMode(.template)
                .scaledToFill()
                .foregroundStyle(.bgBlue)
                .frame(width: 60, height: 60)
            Text("You haven't caught any pokemon yet.")
                .font(.title2)
                .foregroundStyle(.gray)
            Spacer()
        }
    }
}

#Preview {
    MyPokemons()
}
