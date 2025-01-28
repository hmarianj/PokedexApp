//
//  ListView.swift
//  PokedexApp
//
//  Created by MH on 07/01/2025.
//

import SwiftUI

struct CardView: View {
    
    let imageUrl: String
    let name: String
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                titleView
                TagView(content: TagView.Content(description: "Water"), style: TagView.Style.standar)
                TagView(content: TagView.Content(description: "Water"), style: TagView.Style.standar)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background {
            cardImageBackground
        }
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 4)
    }
}

private extension CardView {
    var titleView: some View {
        Text(name.capitalized)
            .font(.system(.title2, weight: .bold))
            .foregroundStyle(.white)
            .multilineTextAlignment(.leading)
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
            name: "Pokemon"
        )
        CardView(
            imageUrl: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/2.png",
            name: "Pokemon"
        )
    }
}
