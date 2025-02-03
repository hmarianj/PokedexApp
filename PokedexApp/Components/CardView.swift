//
//  ListView.swift
//  PokedexApp
//
//  Created by MH on 07/01/2025.
//

import SwiftUI
import UIImageColors

struct CardView: View {
    
    @State private var backgroundColor: Color = .gray.opacity(0.2)
    let imageUrl: String
    let name: String
    let id: Int
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                titleSection
                numberIDSection
                Spacer() // TODO: check this in preview
            }
        }
        .frame(maxWidth: .infinity, minHeight: 90 ,alignment: .leading)
        .padding()
        .background {
            cardImageBackground
        }
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 4)
    }
}

private extension CardView {
    var titleSection: some View {
        Text(name.capitalized)
            .font(.system(.title2, weight: .bold))
            .foregroundStyle(.white)
            .multilineTextAlignment(.leading)
    }
    
    var numberIDSection: some View {
        Text("Nº\(String(format: "%03d", id))")
            .font(.system(.caption2, weight: .semibold))
            .foregroundStyle(.gray)
            .padding(.horizontal, 12)
            .padding(.vertical, 4)
            .background(.white)
            .cornerRadius(16)
    }
    
    var pokeballImageBackground: some View {
        Image("pokeball-bg")
            .resizable()
            .frame(width: 140, height: 140)
            .offset(x: 30)
    }
    
    var cardImageBackground: some View {
        HStack {
            Spacer()
            ZStack(alignment: .trailingFirstTextBaseline) {
                pokeballImageBackground
                AsyncImage(url: URL(string: imageUrl)) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 80, height: 80)
                } placeholder: {
                    ProgressView()
                }
                .padding(.bottom, 4)
            }
        }
        .background(Color.cyan.opacity(0.4))
    }
}


#Preview {
    HStack {
        CardView(
            imageUrl: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/2.png",
            name: "Pokemon",
            id: 007
        )
        CardView(
            imageUrl: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/8.png",
            name: "Pokemon",
            id: 008
        )
    }
}
